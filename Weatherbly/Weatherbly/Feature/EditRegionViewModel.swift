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
    func didTapTableViewCell(_ indexPath: IndexPath)
    func didTapConfirmButton()
    func toSettingRegionView()
}


public final class EditRegionViewModel: RxBaseViewModel, EditRegionViewModelLogic {
    public var loadedListRelay = BehaviorRelay<[AddressInfo]>(value: [])
    
    public func loadRegionList() {
        let dataSource = UserDataSource()
        dataSource.getAddressList(UserDefaultManager.shared.nickname)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    guard let data = response.data else { return }
                    self.loadedListRelay.accept(data.list)
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self.alertMessageRelay.accept(.init(title: errorString, alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func didTapTableViewCell(_ indexPath: IndexPath) {
        
    }
    
    public func didTapConfirmButton() {
        toSettingRegionView()
    }
    
    public func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
