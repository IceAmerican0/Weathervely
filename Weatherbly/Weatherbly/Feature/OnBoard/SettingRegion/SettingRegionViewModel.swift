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
    public var searchedListRelay = BehaviorRelay<[Document]>(value: [])
    
    public func searchRegion(_ region: String) {
        let datasource = RegionDataSource()
        datasource.searchRegion(region)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    if response.meta.totalCount == 0 {
                        self.alertMessageRelay.accept(.init(title: "해당하는 동네 정보가 없어요",
                                                            message: "동네 이름을 확인해주세요",
                                                            alertType: .Error))
                    } else {
                        self.searchedListRelay.accept(response.documents)
                    }
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self.alertMessageRelay.accept(.init(title: errorString,
                                                        alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func didTapTableViewCell(at: IndexPath) {
        guard let address = searchedListRelay.value[at.row].address else { return }
        let addressRequest = AddressRequest(address_name: address.addressName,
                                            city: address.region1DepthName,
                                            gu: address.region2DepthName,
                                            dong: address.region3DepthName,
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

