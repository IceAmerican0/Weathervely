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
    func toCompleteView(nickname: String)
    
    var errorMessage: PublishRelay<String> { get }
}

final class NicknameViewModel: RxBaseViewModel, NicknameViewModelLogic {
    var errorMessage: PublishRelay<String> = .init()
    
    func didTapConfirmButton(_ text: String) {
        // TODO: API 추가 후 변경
//        let dataSource = AuthDataSource()
//        dataSource.setNickname("", "")
//            .subscribe(
//                with: self,
//                onNext: { owner, nickname in
//                    owner.toCompleteView(nickname: "")
//                },
//                onError: { owner, error in
//                    owner.errorMessage.accept(error.localizedDescription)
//                }
//            ).disposed(by: bag)
        toCompleteView(nickname: text)
    }
    
    func toCompleteView(nickname: String) {
        let vc = NicknameCompleteViewController(NicknameCompleteViewModel(nickname: nickname))
        navigationPushViewControllerRelay.accept(vc)
    }
}
