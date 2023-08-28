//
//  ChangeNicknameViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/12.
//

import RxSwift

public protocol ChangeNicknameViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton(_ userInfo: UserInfoRequest)
}

class ChangeNicknameViewModel: RxBaseViewModel, ChangeNicknameViewModelLogic {
    func didTapConfirmButton(_ userInfo: UserInfoRequest) {
        let dataSource = UserDataSource()
        dataSource.fetchUserInfo(userInfo)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    userDefault.set(userInfo.nickname, forKey: UserDefaultKey.nickname.rawValue)
                    // TODO: 추후 성별 추가시 주석 풀기
//                    userDefault.set(userInfo.gender, forKey: UserDefaultKey.gender.rawValue)
                    userDefault.synchronize()
                    self?.navigationPopViewControllerRelay.accept(Void())
                case .failure(let err):
                    switch err {
                    case .noInternetError:
                        self?.navigationPushViewControllerRelay.accept(LoadErrorViewController(LoadErrorViewModel()))
                    default:
                        guard let errorString = err.errorDescription else { return }
                        self?.alertMessageRelay.accept(.init(title: errorString,
                                                            alertType: .Error))
                    }
                }
            })
            .disposed(by: bag)
    }
}
