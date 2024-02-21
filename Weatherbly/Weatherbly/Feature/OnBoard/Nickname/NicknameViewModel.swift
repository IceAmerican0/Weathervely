//
//  NicknameViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/19.
//

import Foundation
import RxSwift
import RxRelay

public protocol NicknameViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton(_ text: String)
    
    var errorMessage: PublishRelay<String> { get }
}

final class NicknameViewModel: RxBaseViewModel, NicknameViewModelLogic {
    var errorMessage: PublishRelay<String> = .init()
    
    func didTapConfirmButton(_ text: String) {
        let vc = NicknameCompleteViewController(NicknameCompleteViewModel(nickname: text))
        navigationPushViewControllerRelay.accept(vc)
    }
}
