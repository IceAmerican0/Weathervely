//
//  MapViewModel.swift
//  Weatherbly
//
//  Created by Khai on 8/30/24.
//

import UIKit
import CoreLocation

public protocol MapViewModelLogic: ViewModelBusinessLogic {
    func poiTapped()
    func goToSetting()
}

public final class MapViewModel: RxBaseViewModel, MapViewModelLogic {
    private let dataSource: RegionDataSourceProtocol = RegionDataSource()
    
    public func poiTapped() {
        
    }
    
    public func goToSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
}
