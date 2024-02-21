//
//  SettingViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/09.
//

import UIKit
import RxRelay
import SafariServices

public protocol SettingViewModelLogic: ViewModelBusinessLogic {
    func toEditNicknameView()
    func toEditRegionView()
    func toBeContinue()
    func didTapCollectionViewCell(at index: Int)
    func didTapTableViewCell(at index: Int)
    
    var profileMenuTitle: BehaviorRelay<[ProfileMenuTitle]> { get }
    var menuTitle: BehaviorRelay<[SettingMenuTitle]> { get }
}

final class SettingViewModel: RxBaseViewModel, SettingViewModelLogic {
    /// 내 정보 설정 리스트
    public var profileMenuTitle = BehaviorRelay<[ProfileMenuTitle]>(
        value: ProfileMenuTitle.allCases.map { $0 }
    )
    /// 앱 설정 리스트
    public var menuTitle = BehaviorRelay<[SettingMenuTitle]>(
        value: SettingMenuTitle.allCases.map { $0 }
    )
    
    func didTapCollectionViewCell(at index: Int) {
        let data = profileMenuTitle.value
        switch data[index] {
        case .region:
            toEditRegionView()
        case .wishList, .sensoryTemp:
            toBeContinue()
        }
    }
    
    func didTapTableViewCell(at index: Int) {
        let data = menuTitle.value
        switch data[index] {
        case .share, .inquiry, .logout, .openSource:
            toBeContinue()
        case .policy:
            toPrivacyPolicyView()
        case .noti, .versionInfo:
            break
        }
    }
    
    func toEditNicknameView() {
        let vc = EditNicknameViewController(EditNicknameViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel(.edit))
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toPrivacyPolicyView() {
        let urlString = "https://docs.google.com/document/d/1MnwR04jGms26yha2oSdps06Ju0wMn-hGS1Zs6JtDAf8/edit?usp=sharing"
        if let url = URL(string: urlString) {
            let webView = SFSafariViewController(url: url)
            presentViewControllerNoAnimationRelay.accept(webView)
        }
    }
    
    func toBeContinue() {
        alertState.accept(.init(title: "준비 중인 기능이에요",
                                       alertType: .toast))
    }
  
}
