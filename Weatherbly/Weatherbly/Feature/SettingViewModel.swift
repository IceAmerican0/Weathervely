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
    func toBeContinue()
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
    
    func toPrivacyPolicyView() {
        let vc = PrivatePolicyViewController(PrivatePolicyViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toBeContinue() {
        alertMessageRelay.accept(.init(title: "준비 중인 기능이에요",
                                       alertType: .Info))
    }
  
}
