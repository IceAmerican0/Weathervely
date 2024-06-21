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
    
    /// 확인 버튼
    func didTapConfirmButton(_ text: String) {
        let dataSource: AuthDataSourceProtocol = AuthDataSource()
        dataSource.nicknameValidation(text)
            .subscribe(
                with: self,
                onNext: { owner, nickname in
                    owner.toCompleteView(nickname: text)
                },
                onError: { owner, error in
                    owner.errorMessage.accept(error.localizedDescription)
                }
            ).disposed(by: bag)
    }
    
    /// 닉네임 확인 뷰
    private func toCompleteView(nickname: String) {
        let vc = NicknameCompleteViewController(NicknameCompleteViewModel(nickname: nickname))
        navigationPushViewControllerRelay.accept(vc)
    }
}
