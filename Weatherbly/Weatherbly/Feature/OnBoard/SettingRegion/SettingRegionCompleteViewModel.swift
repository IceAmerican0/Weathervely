//
//  SettingRegionCompleteViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/24.
//

import Foundation
import RxSwift
import RxCocoa

public protocol SettingRegionCompleteViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton()
    func toEditRegionView()
    func toSelectGenderView()
}

public final class SettingRegionCompleteViewModel: RxBaseViewModel, SettingRegionCompleteViewModelLogic {
    public let regionDataRelay: BehaviorRelay<AddressRequest>
    
    init(_ item: AddressRequest) {
        self.regionDataRelay = BehaviorRelay<AddressRequest>(value: item)
        super.init()
    }
    
    public func didTapConfirmButton() {
        let dataSource = AuthDataSource()
        dataSource.setAddress(regionDataRelay.value)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    if UserDefaultManager.shared.isOnBoard {
                        userDefault.set(self.regionDataRelay.value, forKey: UserDefaultKey.region.rawValue)
                        self.toSelectGenderView()
                    } else {
                        self.toEditRegionView()
                    }
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
    
    public func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    public func toSelectGenderView() {
        let vc = SelectGenderViewController(SelectGenderViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
