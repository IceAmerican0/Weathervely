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
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    userDefault.set(userInfo.nickname, forKey: UserDefaultKey.nickname.rawValue)
                    // TODO: 추후 성별 추가시 주석 풀기
//                    userDefault.set(userInfo.gender, forKey: UserDefaultKey.gender.rawValue)
                    userDefault.synchronize()
                    owner.navigationPopViewControllerRelay.accept(Void())
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                        alertType: .popup))
            })
            .disposed(by: bag)
    }
}
