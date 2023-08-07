//
//  SettingRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import RxRelay
import RxSwift
import UIKit

public protocol SettingRegionViewModelLogic: ViewModelBusinessLogic {
    func searchRegion(_ region: String)
    func didTapTableViewCell(at: IndexPath)
    func toCompleteViewController(_ viewModel: SettingRegionCompleteViewModel)
}

public final class SettingRegionViewModel: RxBaseViewModel, SettingRegionViewModelLogic {
    public var searchedListRelay = BehaviorRelay<[SearchRegionEntity]>(value: [])
    
    public func searchRegion(_ region: String) {
        let datasource = RegionDataSource()
        
        datasource.searchRegion(region)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.searchedListRelay.accept([response])
                case .failure(let err):
                    print(err.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    public func setRegionName(at: IndexPath) -> String {
        searchedListRelay.value[0].documents[at.row].addressName
    }
    
    public func didTapTableViewCell(at: IndexPath) {
        let address = searchedListRelay.value[0].documents[at.row].address
        let addressRequest = AddressRequest(address_name: address.addressName,
                                            city: address.region1DepthName,
                                            gu: address.region2DepthName,
                                            dong: address.region3DepthName,
                                            postal_code: "",
                                            country: "kr",
                                            x_code: Int(address.y),
                                            y_code: Int(address.x))
        let nextModel = SettingRegionCompleteViewModel(addressRequest)
        toCompleteViewController(nextModel)
    }
    
    public func toCompleteViewController(_ viewModel: SettingRegionCompleteViewModel) {
        let vc = SettingRegionCompleteViewController(viewModel)
        navigationPushViewControllerRelay.accept(vc)
    }
}

/// 성공 
/// 500 -> sql, 우리 로직
/// 503 -> 서비스 접근 x (기상청에 접근 안댐) -> 기상청에 문제가 생김.
/// 400 -> 요청 잘못
/// 401 -> autorization
/// 404 -> notFound

