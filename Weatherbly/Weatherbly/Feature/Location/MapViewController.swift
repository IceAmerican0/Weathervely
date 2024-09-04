//
//  MapViewController.swift
//  Weatherbly
//
//  Created by Khai on 8/30/24.
//

import UIKit
import Then
import FlexLayout
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
    
    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(mapContainer).grow(1)
        }
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
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLongitude = location.coordinate.longitude
        currentLatitude = location.coordinate.latitude
    }
}

// MARK: MapControllerDelegate
extension MapViewController {
    public func addViews() {
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: currentLongitude, latitude: currentLatitude)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 13)
        
        //KakaoMap 추가.
        mapController.addView(mapviewInfo)
    }
    
    public func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController.getView("mapview") as! KakaoMap
        view.viewRect = mapContainer.bounds
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
