//
//  SettingRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import RxRelay
import RxSwift
import UIKit

public enum SettingRegionState: String {
    /// 온보딩
    case onboard
    /// 주소 변경
    case change
    /// 주소 추가
    case add
}

public protocol SettingRegionViewModelLogic: ViewModelBusinessLogic {
    func searchRegion(_ region: String)
    func didTapTableViewCell(at: IndexPath)
    func toCompleteViewController(_ viewModel: SettingRegionCompleteViewModel)
}

public final class SettingRegionViewModel: RxBaseViewModel, SettingRegionViewModelLogic {
    public var searchedListRelay = BehaviorRelay<[Document]>(value: [])
    public let settingRegionState: SettingRegionState
    
    public init(_ settingRegionState: SettingRegionState) {
        self.settingRegionState = settingRegionState
    }
    
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
                        let validDocuments = response.documents.filter { document in
                            // 필요한 검증 조건을 추가하십시오.
                            // 예를 들어, region2DepthName, region3DepthHName, region3DepthName 이 nil이 아닐 때를 조건으로 추가
                            return document.address?.region3DepthHName != nil && document.address?.region3DepthName != nil && document.roadAddress?.region3DepthName != nil
                        }
                        print(validDocuments)
                        self.searchedListRelay.accept(validDocuments)
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
        var addressRequest = AddressRequest()
        if let address = searchedListRelay.value[at.row].address {
            addressRequest = AddressRequest(address_name: address.addressName,
                                                city: address.region1DepthName,
                                                gu: address.region2DepthName,
                                                dong: address.region3DepthName.isEmpty ? address.region3DepthHName : address.region3DepthName,
                                                country: "kr",
                                                x_code: Double(address.y) ?? 0,
                                                y_code: Double(address.x) ?? 0)
        } else {
            guard let address = searchedListRelay.value[at.row].roadAddress else { return }
            addressRequest = AddressRequest(address_name: address.addressName,
                                            city: address.region1DepthName,
                                            gu: address.region2DepthName,
                                            dong: address.region3DepthName,
                                            country: "kr",
                                            x_code: Double(address.y) ?? 0,
                                            y_code: Double(address.x) ?? 0)
        }
        
        var nextModel: SettingRegionCompleteViewModel {
            switch settingRegionState {
            case .onboard:
                return SettingRegionCompleteViewModel(addressRequest, .onboard)
            case .change:
                return SettingRegionCompleteViewModel(addressRequest, .change)
            case .add:
                return SettingRegionCompleteViewModel(addressRequest, .add)
            }
        }
        
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

