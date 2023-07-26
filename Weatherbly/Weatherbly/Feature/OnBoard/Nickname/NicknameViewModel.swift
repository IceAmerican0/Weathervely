//
//  NicknameViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/19.
//

import Foundation

public protocol NicknameViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton()
    func toSettingRegionView()
}

final class NicknameViewModel: RxBaseViewModel, NicknameViewModelLogic {
    func didTapConfirmButton() {
        toSettingRegionView()
    }
    
    func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
