//
//  SelectGenderViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/22.
//

import RxSwift
import RxCocoa

public protocol SelectGenderViewModelLogic: ViewModelBusinessLogic {
    func didTapAcceptButton(_ gender: String)
    func toDateTimePickView()
}

final class SelectGenderViewModel: RxBaseViewModel, SelectGenderViewModelLogic {
    public func didTapAcceptButton(_ gender: String) {
        let dataSource = AuthDataSource()
        dataSource.setGender(gender)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    userDefault.set(gender == "female" ? "여성" : "남성", forKey: UserDefaultKey.gender.rawValue)
                    owner.toDateTimePickView()
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup))
            })
            .disposed(by: bag)
    }
    
    public func toDateTimePickView() {
        let vc = DateTimePickViewController(DateTimePickViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
}
