//
//  SettingRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import RxRelay
import RxSwift
import UIKit

public enum SettingRegionViewAction {
    case showMessage(message: String, isError: Bool)
}

public protocol SettingRegionViewModelLogic: ViewModelBusinessLogic {
    func searchRegion(_ region: String)
    func didTapTableViewCell(at: IndexPath)
    func toCompleteViewController()
    var viewAction: PublishRelay<SettingRegionViewAction> { get }
}

public final class SettingRegionViewModel: RxBaseViewModel, SettingRegionViewModelLogic {
    public var viewAction: PublishRelay<SettingRegionViewAction>
    public var searchedListRelay = BehaviorRelay<[SearchRegionEntity]>(value: [])
    
    override public init() {
        self.viewAction = .init()
        super.init()
    }
    
    public func searchRegion(_ region: String) {
        let datasource = RegionDataSource()
        
        datasource.searchRegion(region)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    self.searchedListRelay = BehaviorRelay<[SearchRegionEntity]>(value: [response])
                    print(response)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    public func setRegionName(at: IndexPath) -> String {
//        let filteredList = searchedListRelay.value.filter {
//            guard let searchRegionEntity = $0 as? SearchRegionEntity else {
//                return false
//            }
//            return searchRegionEntity.documents[at.row].addressName
//        }
//        let regionName = "\(address.region1DepthName) \(address.region2DepthName) \(address.region3DepthName)"
        return ""
    }
    
    public func didTapTableViewCell(at: IndexPath) {
        toCompleteViewController()
    }
    
    public func toCompleteViewController() {
        // TODO: 온보딩시 / 아닐시 구분
        let vc = SettingRegionCompleteViewController(SettingRegionCompleteViewModel())
        vc.isFromEdit = false ? true : false
        return navigationPushViewControllerRelay.accept(vc)
    }
}

/// 성공 
/// 500 -> sql, 우리 로직
/// 503 -> 서비스 접근 x (기상청에 접근 안댐) -> 기상청에 문제가 생김.
/// 400 -> 요청 잘못
/// 401 -> autorization
/// 404 -> notFound

