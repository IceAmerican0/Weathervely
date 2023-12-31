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
    func deleteRegion(_ indexPath: IndexPath)
    func updateMainRegion(_ indexPath: IndexPath)
    func didTapCellButton(_ indexPath: IndexPath)
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
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    guard let list = response.data?.list else { return }
                    self?.loadedListRelay.accept(list)
                    switch self?.editRegionState {
                    case .edit:
                        break
                    case .change:
                        self?.alertMessageRelay.accept(.init(title: "현재 동네가 \(UserDefaultManager.shared.dong)(으)로 변경됐어요",
                                                             alertType: .Info))
                    case .add:
                        self?.alertMessageRelay.accept(.init(title: "동네가 추가됐어요",
                                                             alertType: .Info))
                    case .none:
                        break
                    }
                case .failure(let err):
                    switch err {
                    case .noInternetError:
                        self?.navigationPushViewControllerRelay.accept(LoadErrorViewController(LoadErrorViewModel()))
                    default:
                        guard let errorString = err.errorDescription else { return }
                        self?.alertMessageRelay.accept(.init(title: errorString,
                                                            alertType: .Error,
                                                            closeAction: {
                            self?.navigationPopViewControllerRelay.accept(Void())
                        }))
                    }
                }
            })
            .disposed(by: bag)
    }
    
    public func deleteRegion(_ indexPath: IndexPath) {
        editRegionState = .edit
        let regionInfo = loadedListRelay.value[indexPath.row]
        dataSource.deleteAddress(regionInfo.id)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.loadRegionList()
                    self?.alertMessageRelay.accept(.init(title: "선택한 동네가 삭제됐어요",
                                                         alertType: .Info))
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
    
    public func updateMainRegion(_ indexPath: IndexPath) {
        editRegionState = .edit
        let regionInfo = loadedListRelay.value[indexPath.row]
        dataSource.setMainAddress(regionInfo.id)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.loadRegionList()
                    userDefault.set(regionInfo.dong, forKey: UserDefaultKey.dong.rawValue)
                    self?.alertMessageRelay.accept(.init(title: "현재 동네가 \(regionInfo.dong)(으)로 변경됐어요",
                                                         alertType: .Info))
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
    
    public func didTapCellButton(_ indexPath: IndexPath) {
        let regionInfo = loadedListRelay.value
        if regionInfo.count == 1 {
            userDefault.set(regionInfo[indexPath.row].id, forKey: UserDefaultKey.regionID.rawValue)
            toSettingRegionView(.change)
        } else {
            deleteRegion(indexPath)
        }
    }
    
    public func didTapConfirmButton() {
        if loadedListRelay.value.count == 3 {
            alertMessageRelay.accept(.init(title: "동네는 최대 3개까지 지정할 수 있어요",
                                           alertType: .Info))
        } else {
            toSettingRegionView(.add)
        }
    }
    
    public func toSettingRegionView(_ settingRegionState: SettingRegionState) {
        let vc = SettingRegionViewController(SettingRegionViewModel(settingRegionState))
        navigationPushViewControllerRelay.accept(vc)
    }
}
