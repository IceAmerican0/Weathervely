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
    var regionDataRelay: BehaviorRelay<AddressRequest> { get }
}

public final class SettingRegionCompleteViewModel: RxBaseViewModel, SettingRegionCompleteViewModelLogic {
    public var regionDataRelay: BehaviorRelay<AddressRequest>
    
    init(regionDataRelay: BehaviorRelay<AddressRequest>) {
        self.regionDataRelay = regionDataRelay
    }
    
    public func didTapConfirmButton() {
        let dataSource = AuthDataSource()
        dataSource.setAddress(regionDataRelay.value)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    // TODO: 온보딩시 / 아닐시 구분
                    true ? self.toSelectGenderView() : self.toEditRegionView()
                    print(response)
                case .failure(let err):
                    print(err.localizedDescription)
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
