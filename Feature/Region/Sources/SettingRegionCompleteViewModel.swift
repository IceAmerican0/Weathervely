//
//  SettingRegionCompleteViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/24.
//

import WVAlert
import UIUtil
import WVNetwork
import Foundation
import RxCocoa

public protocol SettingRegionCompleteViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton()
    func setAddress()
    func changeAddress()
    func addAddress()
}

public final class SettingRegionCompleteViewModel: RxBaseViewModel, SettingRegionCompleteViewModelLogic {
    public let regionDataRelay: BehaviorRelay<AddressRequest>
    public let settingRegionState: SettingRegionState
    private let authDataSource: AuthDataSourceProtocol = AuthDataSource()
    private let userDataSource: UserDataSourceProtocol = UserDataSource()
    
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
                    userDefault.removeObject(forKey: UserDefaultKey.isOnboard.rawValue)
                    owner.toHomeView()
                },
                onError: { owner, error in
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
                }
            ).disposed(by: bag)
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
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
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
                    var closeAction: AlertActionHandler?
                    
                    if errorString == "중복된 주소를 등록 했습니다." {
                        closeAction = { owner.navigationPopViewControllerRelay.accept(Void()) }
                    }
                    
                    AlertManager.shared.present(
                        state: .init(
                            title: errorString,
                            closeAction: closeAction
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    private func toEditRegionView(_ editRegionState: EditRegionState) {
//        let vc = EditRegionViewController(EditRegionViewModel(editRegionState))
//        navigationPushToPreviousViewControllerRelay.accept([vc])
    }
    
    private func toHomeView() {
//        let vc = HomeTabBarController()
//        navigationSetRootPushViewControllerRelay.accept(vc)
    }
}
