//
//  SelectGenderViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/22.
//

import Foundation
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

public protocol SelectGenderViewModelLogic: ViewModelBusinessLogic {
    func didTapAcceptButton()
    func toSensoryTempView()
}

final class SelectGenderViewModel: RxBaseViewModel, SelectGenderViewModelLogic {
    public func didTapAcceptButton() {
        toSensoryTempView()
    }
    
    public func toSensoryTempView() {
        let vc = OnBoardSensoryTempViewController(OnBoardSensoryTempViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
}
