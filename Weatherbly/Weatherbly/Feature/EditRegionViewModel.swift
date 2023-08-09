//
//  EditRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/25.
//

import RxSwift
import RxCocoa

public protocol EditRegionViewModelLogic: ViewModelBusinessLogic {
    func loadRegionList()
    func didTapTableViewCell()
    func didTapConfirmButton()
    func toSettingRegionView()
}


public final class EditRegionViewModel: RxBaseViewModel, EditRegionViewModelLogic {
    public var loadedListRelay = BehaviorRelay<[AddressEntity]>(value: [])
    
    public func loadRegionList() {
        let dataSource = UserDataSource()
        dataSource.getAddressList(UserDefaultManager.shared.nickname)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.loadedListRelay.accept([response])
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self.alertMessageRelay.accept(.init(title: errorString, alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func didTapTableViewCell() {
        toSettingRegionView()
    }
    
    public func didTapConfirmButton() {
        toSettingRegionView()
    }
    
    public func toSettingRegionView() {
        let vc = SettingRegionViewController(SettingRegionViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
