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
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    userDefault.set(gender == "female" ? "여성" : "남성", forKey: UserDefaultKey.gender.rawValue)
                    self?.toDateTimePickView()
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
    
    public func toDateTimePickView() {
        let vc = DateTimePickViewController(DateTimePickViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
}
