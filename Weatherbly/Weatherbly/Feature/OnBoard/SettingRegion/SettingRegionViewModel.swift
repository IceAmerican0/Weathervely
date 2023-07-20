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
//    var data: BehaviorRelay<[RegionCellState]> { get }
}

public final class SettingRegionViewModel: RxBaseViewModel, SettingRegionViewModelLogic {
    public var viewAction: PublishRelay<SettingRegionViewAction>
    
    private var documents = [Documents]()
    private var addresses = [Address]()
    
    override public init() {
        self.viewAction = .init()
        super.init()
    }
    
    public func searchRegion(_ region: String) {
        let repository = RegionRepository(dataSource: RegionDataSource())
        
        repository.searchRegion(query: region)
            .subscribe(
                with: self,
                onNext: { owner, regionInfo in
                    owner.documents = regionInfo.documents
                },
                onError: { owner, _ in
                    
                }
            )
            .disposed(by: bag)
    }
}
