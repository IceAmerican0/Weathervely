//
//  ChangeNicknameViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/12.
//

import RxSwift

public protocol ChangeNicknameViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton(_ nickname: String, _ gender: String)
}

class ChangeNicknameViewModel: RxBaseViewModel, ChangeNicknameViewModelLogic {
    func didTapConfirmButton(_ nickname: String, _ gender: String) {
        let dataSource = UserDataSource()
        dataSource.fetchUserInfo(UserInfoRequest(nickname: nickname, gender: gender))
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    userDefault.set(nickname, forKey: UserDefaultKey.nickname.rawValue)
                    userDefault.set(gender, forKey: UserDefaultKey.gender.rawValue)
                    self.navigationPopViewControllerRelay.accept(Void())
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    let alertVC = AlertViewController(state: .init(title: errorString,
                                                                   alertType: .Error))
                    alertVC.modalPresentationStyle = .overCurrentContext
                    self.presentViewControllerNoAnimationRelay.accept(alertVC)
                }
            })
            .disposed(by: bag)
    }
}
