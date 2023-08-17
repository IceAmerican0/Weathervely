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
    func toDateTimePickView()
}

public final class SettingRegionCompleteViewModel: RxBaseViewModel, SettingRegionCompleteViewModelLogic {
    public let regionDataRelay: BehaviorRelay<AddressRequest>
    private let authDataSource = AuthDataSource()
    private let userDataSource = UserDataSource()
    
    init(_ item: AddressRequest) {
        self.regionDataRelay = BehaviorRelay<AddressRequest>(value: item)
        super.init()
    }
    
    public func didTapConfirmButton() {
        if UserDefaultManager.shared.isOnBoard == false {
            changeAddress()
        }
        setAddress()
    }
    
    public func setAddress() {
        authDataSource.setAddress(regionDataRelay.value)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    if UserDefaultManager.shared.isOnBoard {
                        self.toDateTimePickView()
                    } else {
                        self.toEditRegionView()
                    }
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self.alertMessageRelay.accept(.init(title: errorString,
                                                        alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func changeAddress() {
        userDataSource.fetchAddress(UserDefaultManager.shared.regionID, regionDataRelay.value)
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    userDefault.removeObject(forKey: UserDefaultKey.regionID.rawValue)
                    self.toEditRegionView()
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self.alertMessageRelay.accept(.init(title: errorString,
                                                        alertType: .Error))
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
    
    public func toDateTimePickView() {
        let vc = DateTimePickViewController(DateTimePickViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
