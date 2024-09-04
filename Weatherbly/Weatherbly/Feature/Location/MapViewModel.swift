//
//  MapViewModel.swift
//  Weatherbly
//
//  Created by Khai on 8/30/24.
//

import UIKit
import CoreLocation

public protocol MapViewModelLogic: ViewModelBusinessLogic {
    func goToSetting()
}

public final class MapViewModel: RxBaseViewModel, MapViewModelLogic {
    public func goToSetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
}
