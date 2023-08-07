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
    func toSettingRegionView()
}

final class NicknameViewModel: RxBaseViewModel, NicknameViewModelLogic {
    func didTapConfirmButton(_ text: String) {
        let dataSource = AuthDataSource()
        dataSource.setNickname(text)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    self.toSettingRegionView()
                    userDefault.set(text, forKey: UserDefaultKey.nickname.rawValue)
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
    
    func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
