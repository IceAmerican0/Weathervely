//
//  EditRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/25.
//

import Foundation
import RxSwift
import RxCocoa

public protocol EditRegionViewModelLogic: ViewModelBusinessLogic {
    func loadRegionList()
    func deleteRegion(_ indexPath: IndexPath)
    func updateMainRegion(_ indexPath: IndexPath)
    func didTapCellButton(_ indexPath: IndexPath)
    func didTapConfirmButton()
    func toSettingRegionView()
}


public final class EditRegionViewModel: RxBaseViewModel, EditRegionViewModelLogic {
    private let dataSource = UserDataSource()
    public var loadedListRelay = BehaviorRelay<[AddressListInfo]>(value: [])
    
    public func loadRegionList() {
        dataSource.getAddressList()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    guard let list = response.data?.list else { return }
                    self?.loadedListRelay.accept(list)
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self?.alertMessageRelay.accept(.init(title: errorString,
                                                        alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func deleteRegion(_ indexPath: IndexPath) {
        let regionInfo = loadedListRelay.value[indexPath.row]
        dataSource.deleteAddress(regionInfo.id)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.alertMessageRelay.accept(.init(title: "선택한 주소가 삭제됐어요",
                                                         alertType: .Info))
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self?.alertMessageRelay.accept(.init(title: errorString,
                                                        alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func updateMainRegion(_ indexPath: IndexPath) {
        let regionInfo = loadedListRelay.value[indexPath.row]
        dataSource.setMainAddress(regionInfo.id)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.alertMessageRelay.accept(.init(title: "현재 동네가 \(regionInfo.addressName)으로 변경됐어요",
                                                         alertType: .Info))
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self?.alertMessageRelay.accept(.init(title: errorString,
                                                        alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func didTapCellButton(_ indexPath: IndexPath) {
        let regionInfo = loadedListRelay.value
        if regionInfo.count == 1 {
            userDefault.set(regionInfo[indexPath.row].id, forKey: UserDefaultKey.regionID.rawValue)
            toSettingRegionView()
        } else {
            deleteRegion(indexPath)
        }
    }
    
    public func didTapConfirmButton() {
        toSettingRegionView()
    }
    
    public func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
