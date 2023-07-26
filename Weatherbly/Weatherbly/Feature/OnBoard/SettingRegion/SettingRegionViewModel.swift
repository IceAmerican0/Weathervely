//
//  SettingRegionViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import RxRelay
import RxSwift

public enum SettingRegionViewAction {
    case showMessage(message: String, isError: Bool)
}

public protocol SettingRegionViewModelLogic: ViewModelBusinessLogic {
    func searchRegion(_ region: String)
    var viewAction: PublishRelay<SettingRegionViewAction> { get }
}

public final class SettingRegionViewModel: RxBaseViewModel, SettingRegionViewModelLogic {
    public var viewAction: PublishRelay<SettingRegionViewAction>
    
    override public init() {
        self.viewAction = .init()
        super.init()
    }
    
    public func searchRegion(_ region: String) {
        let datasource = RegionDataSource()
        
        datasource.searchRegion(region)
            .subscribe(onNext: { result in
                print("result in ViewModel : ", result)
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let err):
                    print(err.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
}

/// 성공 
/// 500 -> sql, 우리 로직
/// 503 -> 서비스 접근 x (기상청에 접근 안댐) -> 기상청에 문제가 생김.
/// 400 -> 요청 잘못
/// 401 -> autorization
/// 404 -> notFound

