//
//  MapViewController.swift
//  Weatherbly
//
//  Created by Khai on 8/30/24.
//

import WVAlert
import UIKit
import CoreLocation
import KakaoMapsSDK

public final class MapViewController: RxBaseViewController<MapViewModel>, MapControllerDelegate {
    private let navigationView = CSNavigationView(.leftButton(.leftArrow_black)).then {
        $0.setTitle("동네 설정")
    }
    
    private let positionContainer = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let positionLabel = LabelMaker(
        font: UIFont.title_2_B,
        alignment: .left
    ).make().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private var confirmButton = CSButton(.standard, style: .violet600).then {
        $0.setTitle("이 위치로 동네 추가하기", for: .normal)
        $0.setTitle("", for: .disabled)
    }
    
    private lazy var mapContainer = KMViewContainer().then {
        $0.sizeToFit()
    }
    
    private lazy var mapController = KMController(viewContainer: mapContainer).then {
        $0.delegate = self
    }
    
    private lazy var locationManager = CLLocationManager().then {
        $0.delegate = self
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation()
    }
    
    private var poi: Poi?
    
    private var auth = false
    private var appear = false
    private var observerAdded = false
    
    private var currentLongitude: Double = 127.108678
    private var currentLatitude: Double = 37.402001
    
    private var cameraStoppedHandler: DisposableEventHandler?
    private var cameraStartHandler: DisposableEventHandler?
    
    deinit {
        mapController.pauseEngine()
        mapController.resetEngine()
        cameraStartHandler?.dispose()
        cameraStoppedHandler?.dispose()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(
            navigationView,
            mapContainer,
            positionContainer
        )
        
        positionContainer.addSubviews(
            positionLabel,
            confirmButton
        )
        
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
        
        navigationView.pin.top(view.pin.safeArea.top).horizontally().height(44)
        positionContainer.pin.horizontally().bottom().height(150)
        positionLabel.pin.top(to: positionContainer.edge.top).horizontally(20).marginTop(20).height(positionLabel.font.lineHeight)
        confirmButton.pin.horizontally(52).bottom(view.pin.safeArea.bottom).height(48)
        mapContainer.pin.below(of: navigationView).horizontally().bottom(to: positionContainer.edge.top)
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self) { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with:self) { owner, _ in
                owner.viewModel.didTapConfirmButton()
            }
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.isLoading
            .asDriver()
            .drive(with: self) { owner, loading in
                if loading {
                    owner.confirmButton.startAnimation()
                } else {
                    owner.confirmButton.stopAnimation()
                }
            }.disposed(by: bag)
        
        viewModel.pickedAddress
            .filter { !$0.isEmpty }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, result in
                owner.positionLabel.text = result
            }.disposed(by: bag)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        observerAdded = true
    }
     
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)

        observerAdded = false
    }

    @objc func willResignActive() {
        mapController.pauseEngine()
    }

    @objc func didBecomeActive() {
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
            
            AlertManager.shared.present(
                state: .init(
                    title: "위치 권한을 설정해주세요.",
                    buttonListState: .double(
                        left: laterState,
                        right: goSettingState
                    )
                )
            )
        @unknown default:
            AlertManager.shared.present(
                state: .init(
                    title: "다시 시도해주세요.",
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
        AlertManager.shared.present(
            state: .init(
                title: "위치를 불러오지 못했어요.\n다시 시도해주세요.",
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
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
        
        //KakaoMap 추가.
        mapController.addView(mapviewInfo)
    }
    
    public func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer.bounds
        view.setMargins(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        viewModel.getCoordToRegion(longitude: currentLongitude, latitude: currentLatitude)
        
        setPoi()
        setSpriteGUI()
        setCameraOption()
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
            AlertManager.shared.present(
                state: .init(
                    title: "지도 불러오기를 실패했어요\n 다시 시도해주세요",
                    closeAction: {
                        self.viewModel.navigationPopViewControllerRelay.accept(Void())
                    }
                )
            )
        }
    }
}

// MARK: Poi
extension MapViewController {
    private func setPoi() {
        let view = mapController.getView("mapview") as! KakaoMap
        let labelManager = view.getLabelManager()
        let trackingManager = view.getTrackingManager()
        
        let layerOption = LabelLayerOptions(
            layerID: "PoiLayer",
            competitionType: .none,
            competitionUnit: .poi,
            orderType: .rank,
            zOrder: 10001
        )
        
        let _ = labelManager.addLabelLayer(option: layerOption)
        
        // Icon Style
        let iconStyle = PoiIconStyle(
            symbol: .icon_location.reDesign(size: CGSize(width: 30, height: 30)),
            anchorPoint: CGPoint(x: 0.5, y: 0.5)
        )
        
        // Text Style
        let textStyle = TextStyle(
            fontSize: 50,
            fontColor: .black, 
            font: GothicNeo.bold
        )
        let textLineStyle = PoiTextLineStyle(textStyle: textStyle)
        let poiTextStyle = PoiTextStyle(textLineStyles: [textLineStyle]).then {
            $0.textLayouts = [.top]
        }
        
        // Merge Poi Styles
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, textStyle: poiTextStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
        labelManager.addPoiStyle(poiStyle)
        
        let poiOption = PoiOptions(styleID: "customStyle1", poiID: "poi1").then {
            $0.rank = 0
            $0.clickable = true
        }
        
        let layer = labelManager.getLabelLayer(layerID: "PoiLayer")
        
        let center = view.getPosition(
            CGPoint(
                x: view.viewRect.size.width * 0.5,
                y: view.viewRect.size.height * 0.5
            )
        )
        poi = layer?.addPoi(
            option: poiOption,
            at: center
        )
        
        poi?.show()
    }
}

// MARK: SpriteGUI
extension MapViewController: GuiEventDelegate {
    private func setSpriteGUI() {
        let mapView: KakaoMap = mapController.getView("mapview") as! KakaoMap
        let spriteLayer = mapView.getGuiManager().spriteGuiLayer
        
        let button = GuiButton("button")
        let buttonImage: UIImage = .icon_current_location
        button.image = buttonImage.reDesign(size: CGSize(width: 25, height: 25), backgroundColor: .white)
        
        let spriteGui = SpriteGui("buttonGui")
        spriteGui.addChild(button)
        spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .right)
        spriteGui.position = CGPoint(x: 40, y: 50)
        spriteGui.delegate = self
        
        spriteLayer.addSpriteGui(spriteGui)
        spriteGui.show()
    }
    
    public func guiDidTapped(_ gui: GuiBase, componentName: String) {
        let view = mapController.getView("mapview") as! KakaoMap
        view.moveCamera(
            CameraUpdate.make(
                target: MapPoint(
                    longitude: currentLongitude,
                    latitude: currentLatitude
                ),
                zoomLevel: 15,
                rotation: 0,
                tilt: 0,
                mapView: view
            )
        )
    }
}

// MARK: Camera
extension MapViewController {
    
    func setCameraOption() {
        let mapView = mapController.getView("mapview") as! KakaoMap
        cameraStartHandler = mapView.addCameraWillMovedEventHandler(target: self, handler: MapViewController.cameraWillMove)
        cameraStoppedHandler = mapView.addCameraStoppedEventHandler(target: self, handler: MapViewController.onCameraStopped)
    }
    
    func cameraWillMove(_ param: CameraActionEventParam) {
        viewModel.isLoading.accept(true)
    }
    
    func onCameraStopped(_ param: CameraActionEventParam) {
        let mapView = param.view as! KakaoMap
        let position = mapView.getPosition(CGPoint(x: 0.5, y: 0.5))
        
        let pickedLongitude = position.wgsCoord.longitude
        let pickedLatitude = position.wgsCoord.latitude
        
        viewModel.getCoordToRegion(longitude: pickedLongitude, latitude: pickedLatitude)
    }
}
