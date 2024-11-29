//
//  NicknameViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/19.
//

import UIUtil
import WVNetwork
import Foundation
import RxCocoa

public protocol NicknameViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton(_ text: String)
    
    var errorMessage: PublishRelay<String> { get }
    var savedNickname: PublishRelay<String> { get }
}

public final class NicknameViewModel: RxBaseViewModel, NicknameViewModelLogic {
    public var errorMessage: PublishRelay<String> = .init()
    public var savedNickname: PublishRelay<String> = .init()
    
    /// 확인 버튼
    public func didTapConfirmButton(_ text: String) {
        let dataSource: AuthDataSourceProtocol = AuthDataSource()
        dataSource.nicknameValidation(text)
            .subscribe(
                with: self,
                onNext: { owner, nickname in
                    owner.savedNickname.accept(text)
                },
                onError: { owner, error in
                    owner.errorMessage.accept(error.localizedDescription)
                }
            ).disposed(by: bag)
    }
}
