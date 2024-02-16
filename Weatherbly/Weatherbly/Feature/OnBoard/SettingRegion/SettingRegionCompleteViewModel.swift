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
    func setAddress()
    func changeAddress()
    func addAddress()
    func toEditRegionView(_ editRegionState: EditRegionState)
    func toSelectGenderView()
    func toDateTimePickView()
}

public final class SettingRegionCompleteViewModel: RxBaseViewModel, SettingRegionCompleteViewModelLogic {
    public let regionDataRelay: BehaviorRelay<AddressRequest>
    public let settingRegionState: SettingRegionState
    private let authDataSource = AuthDataSource()
    private let userDataSource = UserDataSource()
    
    public init(_ item: AddressRequest, _ settingRegionState: SettingRegionState) {
        self.regionDataRelay = BehaviorRelay<AddressRequest>(value: item)
        self.settingRegionState = settingRegionState
        super.init()
    }
    
    public func didTapConfirmButton() {
        switch settingRegionState {
        case .onboard:
            setAddress()
        case .change:
            changeAddress()
        case .add:
            addAddress()
        }
    }
    
    public func setAddress() {
        authDataSource.setAddress(regionDataRelay.value)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    userDefault.set(owner.regionDataRelay.value.dong, forKey: UserDefaultKey.dong.rawValue)
                    owner.toDateTimePickView()
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup))
            })
            .disposed(by: bag)
    }
    
    public func changeAddress() {
        userDataSource.fetchAddress(UserDefaultManager.shared.regionID, regionDataRelay.value)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    userDefault.set(owner.regionDataRelay.value.dong, forKey: UserDefaultKey.dong.rawValue)
                    userDefault.removeObject(forKey: UserDefaultKey.regionID.rawValue)
                    owner.toEditRegionView(.change)
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup))
            })
            .disposed(by: bag)
    }
    
    public func addAddress() {
        userDataSource.addAddress(regionDataRelay.value)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.toEditRegionView(.add)
                },
                onError: { owner, error in
                    let errorString = error.localizedDescription
                    if errorString == "중복된 주소를 등록 했습니다." {
                        owner.alertState.accept(.init(title: errorString,
                                                             alertType: .popup,
                                                             closeAction: {
                            owner.navigationPopViewControllerRelay.accept(Void())
                        }))
                    } else {
                        owner.alertState.accept(.init(title: errorString,
                                                             alertType: .popup))
                    }
            })
            .disposed(by: bag)
    }
    
    public func toEditRegionView(_ editRegionState: EditRegionState) {
        let vc = EditRegionViewController(EditRegionViewModel(editRegionState))
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
