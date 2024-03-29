//
//  SettingRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import RxRelay
import RxSwift
import UIKit

public enum SettingRegionState {
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
            .subscribe(
                with: self,
                onNext: { owner, response in
                    if response.documents.count == 0 {
                        owner.alertState.accept(.init(title: "해당하는 동네 정보가 없어요",
                                                             message: "동네 이름을 확인해주세요",
                                                             alertType: .popup))
                    } else {
                        owner.searchedListRelay.accept(response.documents)
                    }
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup))
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

