//
//  EditRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/25.
//

import Foundation
import RxSwift

public protocol EditRegionViewModelLogic: ViewModelBusinessLogic {
    func didTapTableViewCell()
    func didTapConfirmButton()
    func toSettingRegionView()
}


public final class EditRegionViewModel: RxBaseViewModel, EditRegionViewModelLogic {
    
    public func didTapTableViewCell() {
        toSettingRegionView()
    }
    
    public func didTapConfirmButton() {
        toSettingRegionView()
    }
    
    public func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
