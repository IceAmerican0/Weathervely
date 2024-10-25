//
//  EditRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/25.
//

import Foundation
import RxSwift
import RxCocoa

public enum EditRegionState {
    /// 설정페이지에서 진입시
    case edit
    /// 주소 변경
    case change
    /// 주소 추가
    case add
}

public protocol EditRegionViewModelLogic: ViewModelBusinessLogic {
    func loadRegionList()
    func deleteRegion(_ index: Int) -> Bool
    func updateMainRegion(_ index: Int)
    func didTapCellButton(_ index: Int)
    func toSettingRegionView(_ settingRegionState: SettingRegionState)
}

public final class EditRegionViewModel: RxBaseViewModel, EditRegionViewModelLogic {
    public var loadedListRelay = BehaviorRelay<[AddressListInfo]>(value: [])
    
    private let dataSource: UserDataSourceProtocol = UserDataSource()
    
    public var editRegionState: EditRegionState
    
    public init(_ editRegionState: EditRegionState) {
        self.editRegionState = editRegionState
        super.init()
        self.loadRegionList()
    }
    
    public func loadRegionList() {
        dataSource.getAddressList()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let list = response.data?.list else { return }
                    userDefault.set(list.first?.dong, forKey: UserDefaultKey.dong.rawValue)
                    self.loadedListRelay.accept(list)
                    switch self.editRegionState {
                    case .edit:
                        break
                    case .change:
                        owner.alertState.accept(
                            .init(
                                title: "현재 동네가 \(UserDefaultManager.shared.dong)(으)로 변경됐어요",
                                alertType: .toast
                            )
                        )
                    case .add:
                        owner.alertState.accept(
                            .init(
                                title: "동네가 추가됐어요",
                                alertType: .toast
                            )
                        )
                    }
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup,
                            closeAction: {
                                owner.navigationPopViewControllerRelay.accept(Void())
                            }
                        )
                    )
            })
            .disposed(by: bag)
    }
    
    public func deleteRegion(_ index: Int) -> Bool {
        editRegionState = .edit
        var state: Bool = false
        let regionInfo = loadedListRelay.value[index]
        
        dataSource.deleteAddress(regionInfo.id)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.loadRegionList()
                    owner.alertState.accept(
                        .init(
                            title: "선택한 동네가 삭제됐어요",
                            alertType: .toast
                        )
                    )
                    state = true
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
                    )
                    state = false
            })
            .disposed(by: bag)
        
        return state
    }
    
    public func updateMainRegion(_ index: Int) {
        editRegionState = .edit
        let regionInfo = loadedListRelay.value[index]
        dataSource.setMainAddress(regionInfo.id)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.loadRegionList()
                    userDefault.set(regionInfo.dong, forKey: UserDefaultKey.dong.rawValue)
                    owner.alertState.accept(
                        .init(
                            title: "현재 동네가 \(regionInfo.dong)(으)로 변경됐어요",
                            alertType: .toast
                        )
                    )
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
                    )
            })
            .disposed(by: bag)
    }
    
    public func didTapCellButton(_ index: Int) {
        let regionInfo = loadedListRelay.value
        userDefault.set(regionInfo[index].id, forKey: UserDefaultKey.regionID.rawValue)
        toSettingRegionView(.change)
    }
    
    public func toSettingRegionView(_ settingRegionState: SettingRegionState) {
        let vc = SettingRegionViewController(SettingRegionViewModel(settingRegionState))
        navigationPushViewControllerRelay.accept(vc)
    }
}
