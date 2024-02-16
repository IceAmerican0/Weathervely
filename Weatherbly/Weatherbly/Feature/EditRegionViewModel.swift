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
    func deleteRegion(_ index: Int)
    func updateMainRegion(_ index: Int)
    func didTapCellButton(_ index: Int)
    func didTapConfirmButton()
    func toSettingRegionView(_ settingRegionState: SettingRegionState)
}

public final class EditRegionViewModel: RxBaseViewModel, EditRegionViewModelLogic {
    public var loadedListRelay = BehaviorRelay<[AddressListInfo]>(value: [])
    
    private let dataSource = UserDataSource()
    
    public var editRegionState: EditRegionState
    
    public init(_ editRegionState: EditRegionState) {
        self.editRegionState = editRegionState
    }
    
    public func loadRegionList() {
        dataSource.getAddressList()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let list = response.data?.list else { return }
                    self.loadedListRelay.accept(list)
                    switch self.editRegionState {
                    case .edit:
                        break
                    case .change:
                        owner.alertState.accept(.init(title: "현재 동네가 \(UserDefaultManager.shared.dong)(으)로 변경됐어요",
                                                             alertType: .toast))
                    case .add:
                        owner.alertState.accept(.init(title: "동네가 추가됐어요",
                                                             alertType: .toast))
                    }
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                        alertType: .popup,
                                                        closeAction: {
                        owner.navigationPopViewControllerRelay.accept(Void())
                    }))
            })
            .disposed(by: bag)
    }
    
    public func deleteRegion(_ index: Int) {
        editRegionState = .edit
        let regionInfo = loadedListRelay.value[index]
        dataSource.deleteAddress(regionInfo.id)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.loadRegionList()
                    owner.alertState.accept(.init(title: "선택한 동네가 삭제됐어요",
                                                         alertType: .toast))
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                        alertType: .popup))
            })
            .disposed(by: bag)
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
                    owner.alertState.accept(.init(title: "현재 동네가 \(regionInfo.dong)(으)로 변경됐어요",
                                                         alertType: .toast))
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                        alertType: .popup))
            })
            .disposed(by: bag)
    }
    
    public func didTapCellButton(_ index: Int) {
        let regionInfo = loadedListRelay.value
        if regionInfo.count == 1 {
            userDefault.set(regionInfo[index].id, forKey: UserDefaultKey.regionID.rawValue)
            toSettingRegionView(.change)
        } else {
            deleteRegion(index)
        }
    }
    
    public func didTapConfirmButton() {
        if loadedListRelay.value.count == 3 {
            alertState.accept(.init(title: "동네는 최대 3개까지 지정할 수 있어요",
                                           alertType: .toast))
        } else {
            toSettingRegionView(.add)
        }
    }
    
    public func toSettingRegionView(_ settingRegionState: SettingRegionState) {
        let vc = SettingRegionViewController(SettingRegionViewModel(settingRegionState))
        navigationPushViewControllerRelay.accept(vc)
    }
}
