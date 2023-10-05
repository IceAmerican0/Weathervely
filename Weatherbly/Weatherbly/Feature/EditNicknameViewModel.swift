//
//  EditNicknameViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/11.
//

import UIKit
import RxSwift
import RxCocoa

protocol EditNicknameViewModelLogic: ViewModelBusinessLogic {
    func loadUserInfo()
    func toChangeNicknameView()
}

class EditNicknameViewModel: RxBaseViewModel, EditNicknameViewModelLogic {
    var loadUserInfoRelay = BehaviorRelay<UserInfoEntity?>(value: nil)
    var bottomButtonDidTapRelay = BehaviorRelay<UITextField.editMode>(value: .justShow)
    
    func bottomButtonDidTap() {
        if bottomButtonDidTapRelay.value == .justShow {
            bottomButtonDidTapRelay.accept(.editing)
        } else {
            bottomButtonDidTapRelay.accept(.justShow)
        }
    }
    
    func loadUserInfo() {
        let dataSource = UserDataSource()
        dataSource.getUserInfo(UserDefaultManager.shared.nickname)
            .subscribe(
                with: self,
                onNext: { owner, result in
                    switch result {
                    case .success(let response):
                        userDefault.set(response.nickname, forKey: UserDefaultKey.nickname.rawValue)
                        // TODO: 추후 성별 추가시 주석 풀기
    //                    userDefault.set(response.gender, forKey: UserDefaultKey.gender.rawValue)
                        userDefault.synchronize()
                        owner.loadUserInfoRelay.accept(response)
                    case .failure(let err):
                        switch err {
                        case .noInternetError:
                            owner.navigationPushViewControllerRelay.accept(LoadErrorViewController(LoadErrorViewModel()))
                        default:
                            guard let errorString = err.errorDescription else { return }
                            owner.alertMessageRelay.accept(.init(title: errorString,
                                                                alertType: .Error))
                        }
                    }
            })
            .disposed(by: bag)
    }
    
    func toChangeNicknameView() {
        let vc = ChangeNicknameViewController(ChangeNicknameViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
