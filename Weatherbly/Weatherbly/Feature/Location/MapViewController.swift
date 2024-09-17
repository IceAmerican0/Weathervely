//
//  MapViewController.swift
//  Weatherbly
//
//  Created by Khai on 8/30/24.
//

import UIKit
import Then
import PinLayout
import CoreLocation
import KakaoMapsSDK

public final class MapViewController: RxBaseViewController<MapViewModel>, MapControllerDelegate {
    private lazy var mapContainer = KMViewContainer().then {
        $0.sizeToFit()
    }
    
    private lazy var mapController = KMController(viewContainer: mapContainer).then {
        $0.delegate = self
    }
    
    private lazy var mapView = (mapController.getView("mapview") as! KakaoMap).then {
        $0.changeViewInfo(appName: "openmap", viewInfoName: "kakao_map")
    }
    
    private lazy var locationManager = CLLocationManager().then {
        $0.delegate = self
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation()
    }
    
    private var auth = false
    private var appear = false
    private var observerAdded = false
    
    private var currentLongitude: Double = 127.108678
    private var currentLatitude: Double = 37.402001
    
    deinit {
        mapController.pauseEngine()
        mapController.resetEngine()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapContainer)
        
        configureAuthorizationState(locationManager)
        
        if mapContainer.proMotionDisplay == true {
            mapController.proMotionSupport = true
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        appear = true
        
        if mapController.isEnginePrepared == false {
            mapController.prepareEngine()
        }
        
        if auth && mapController.isEngineActive == false {
            mapController.activateEngine()
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appear = false
        mapController.pauseEngine()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
        mapController.resetEngine()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapContainer.pin.all()
    }
    
    func addObservers(){
         NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
         observerAdded = true
     }
     
     func removeObservers(){
         NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
         NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
     
          observerAdded = false
     }
     
     @objc func willResignActive(){
         mapController.pauseEngine()
     }
     
     @objc func didBecomeActive(){
         mapController.activateEngine()
     }
}

// MARK: CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    public func configureAuthorizationState(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways,
             .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .restricted,
             .denied:
            let laterState = AlertButtonState(
                title: "나중에",
                action: { self.viewModel.navigationPopViewControllerRelay.accept(Void()) }
            )
            let goSettingState = AlertButtonState(
                title: "권한 설정하기",
                action: { self.viewModel.goToSetting() }
            )
            
            viewModel.alertState.accept(
                .init(
                    title: "위치 권한을 설정해주세요.",
                    alertType: .popup,
                    buttonListState: .double(
                        left: laterState,
                        right: goSettingState
                    )
                )
            )
        @unknown default:
            viewModel.alertState.accept(
                .init(
                    title: "다시 시도해주세요.",
                    alertType: .popup,
                    closeAction: { self.viewModel.navigationPopViewControllerRelay.accept(Void()) }
                )
            )
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        configureAuthorizationState(manager)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLongitude = location.coordinate.longitude
        currentLatitude = location.coordinate.latitude
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        viewModel.alertState.accept(
            .init(
                title: "위치를 불러오지 못했어요.\n다시 시도해주세요.",
                alertType: .popup,
                closeAction: { self.viewModel.navigationPopViewControllerRelay.accept(Void()) }
            )
        )
    }
}

// MARK: MapControllerDelegate
extension MapViewController {
    public func addViews() {
        // 여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: currentLongitude, latitude: currentLatitude)
        // 지도(KakaoMap)를 그리기 위한 viewInfo 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 13)
        
        //KakaoMap 추가.
        mapController.addView(mapviewInfo)
    }
    
    public func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer.bounds
        
        setPoi()
        setSpriteGUI()
    }
    
    public func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    public func authenticationSucceeded() {
        if auth == false {
            auth = true
        }
        
        if appear && mapController.isEngineActive == false {
            mapController.activateEngine()
        }
    }
    
    public func authenticationFailed(_ errorCode: Int, desc: String) {
        auth = false
        
        if errorCode == 403 {
            viewModel.goToSetting()
        } else {
            viewModel.alertState.accept(
                .init(
                    title: "지도 불러오기를 실패했어요\n 다시 시도해주세요",
                    alertType: .popup,
                    closeAction: {
                        self.viewModel.navigationPopViewControllerRelay.accept(Void())
                    }
                )
            )
        }
    }
}

extension MapViewController: KakaoMapEventDelegate {
    public func onViewInfoChanged(kakaoMap: KakaoMap, viewInfoName: String) {
        
    }
    
    public func onViewInfoChangeFailure(kakaoMap: KakaoMap, viewInfoName: String) {
        
    }
}

// MARK: Poi
extension MapViewController {
    private func setPoi() {
        let view = mapController.getView("mapview") as! KakaoMap
        let labelManager = view.getLabelManager()
        
        let layerOption = LabelLayerOptions(
            layerID: "PoiLayer",
            competitionType: .none,
            competitionUnit: .poi,
            orderType: .rank,
            zOrder: 10001
        )
        
        let _ = labelManager.addLabelLayer(option: layerOption)
        
        let iconStyle = PoiIconStyle(
            symbol: UIImage(named: "mapIcoBookmark_01.png"),
            anchorPoint: CGPoint(x: 0.0, y: 0.5)
        )
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
        labelManager.addPoiStyle(poiStyle)
        
        let poiOption = PoiOptions(styleID: "customStyle1").then {
            $0.rank = 0
            $0.clickable = true
        }
        
        let layer = labelManager.getLabelLayer(layerID: "PoiLayer")
        
        let poi = layer?.addPoi(
            option: poiOption,
            at: MapPoint(longitude: currentLongitude, latitude: currentLatitude)
        )
        
        let _ = poi?.addPoiTappedEventHandler(target: self, handler: MapViewController.poiTapped)
        poi?.show()
    }
    
    private func poiTapped(_ param: PoiInteractionEventParam) {
        viewModel.poiTapped()
    }
}

// MARK: SpriteGUI
extension MapViewController: GuiEventDelegate {
    private func setSpriteGUI() {
        let mapView: KakaoMap = mapController.getView("mapview") as! KakaoMap
        let guiManager: GuiManager = mapView.getGuiManager()
        let spriteLayer = guiManager.spriteGuiLayer
        
        let button = GuiButton("button")
        button.image = UIImage(named: "track_location_btn.png")
        
        let spriteGui = SpriteGui("buttonGui")
        spriteGui.addChild(button)
        spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .right)
        spriteGui.delegate = self
        
        spriteLayer.addSpriteGui(spriteGui)
        spriteGui.show()
    }
    
    public func guiDidTapped(_ gui: GuiBase, componentName: String) {
        
    }
}
