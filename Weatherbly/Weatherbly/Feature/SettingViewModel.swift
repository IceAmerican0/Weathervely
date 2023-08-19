//
//  SettingViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/09.
//

import UIKit
import RxSwift
import RxRelay
import SafariServices

public protocol SettingViewModelLogic: ViewModelBusinessLogic {
    func toHomeView()
    func toEditNicknameView()
    func toEditRegionView()
    func toBeContinue()
}

final class SettingViewModel: RxBaseViewModel, SettingViewModelLogic {
    func toHomeView() {
        let vc = HomeViewController(HomeViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toEditNicknameView() {
        let vc = EditNicknameViewController(EditNicknameViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toPrivacyPolicyView() {
//        let vc = PrivatePolicyViewController(PrivatePolicyViewModel())
//        navigationPushViewControllerRelay.accept(vc)
        let urlString = "https://docs.google.com/document/d/1MnwR04jGms26yha2oSdps06Ju0wMn-hGS1Zs6JtDAf8/edit?usp=sharing"
        if let url = URL(string: urlString) {
            let webView = SFSafariViewController(url: url)
            presentViewControllerNoAnimationRelay.accept(webView)
        }
    }
    
    func toBeContinue() {
        alertMessageRelay.accept(.init(title: "준비 중인 기능이에요",
                                       alertType: .Info))
    }
  
}
