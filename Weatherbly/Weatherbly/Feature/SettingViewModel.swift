//
//  SettingViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/09.
//

import UIKit
import RxSwift
import RxRelay

public protocol SettingViewModelLogic: ViewModelBusinessLogic {
    func toEditNicknameView()
    func toEditRegionView()
}

final class SettingViewModel: RxBaseViewModel, SettingViewModelLogic {
    
    func toEditNicknameView() {
        let vc = EditNicknameViewController(EditNicknameViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    
  
}
