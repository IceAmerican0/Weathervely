//
//  ClosetDetailViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ClosetDetailViewModel: RxBaseViewModel {
    
    private let closetDetailDataSource = ClosetDetailDataSource()
    
    /// 전체 CollectionView
    public var detailViewSections = BehaviorRelay<[DetailViewSectionModel]>(value: [])
    /// 선택된 옷 정보
    public var selectedClosetInfo = BehaviorRelay<SelectedClosetInfo?>(value: nil)
    /// 함께착용한 아이템 정보
    public var withItemInfo = BehaviorRelay<WithItemsInfo?>(value: nil)
    /// Warmmer closets
    public var warmListInfo = BehaviorRelay<DiffTempClosetList?>(value: nil)
    public var warmFirstRowInfo = BehaviorRelay<FirstRow?>(value: nil)
    public var warmSecondRowInfo = BehaviorRelay<SecondRow?>(value: nil)
    /// Cooler losets
    public var coolListInfo = BehaviorRelay<DiffTempClosetList?>(value: nil)
    public var coolFirstRowInfo = BehaviorRelay<FirstRow?>(value: nil)
    public var coolSecondRowInfo = BehaviorRelay<SecondRow?>(value: nil)
    
    func setSections() {
        let a = selectedClosetInfo.value
        let mockSections : [DetailSectionItem] = [
            .mainDetail(selectedClosetInfo.value!),
            .withItem(withItemInfo.value!),
            .warmmer(warmListInfo.value!),
            .cooler(coolListInfo.value!)
        ]
        
//        detailViewSections.accept(mockSections)
    }
    
    func getClosetDetail(closetId: Int) {
        closetDetailDataSource.getClosetDetail(closetId: closetId)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let data = response.data else { return }
                    if let detailInfo = data.selectedCloset,
                       let withItemInfo = data.selectedCloset?.withItems {
                        owner.selectedClosetInfo.accept(detailInfo)
                        
                        owner.withItemInfo.accept(withItemInfo)
                    }
                })
            .disposed(by: bag)
    }
    
    func getWarmmerClosets(closetId: Int, page: Int) {
        closetDetailDataSource.getWarmmerCloset(closetId: closetId, page: page)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    if let firstRow  = dataList.firstRow,
                       let secondRow = dataList.secondRow {
                        
                        owner.warmFirstRowInfo.accept(firstRow)
                        owner.warmSecondRowInfo.accept(secondRow)
                    }
                }).disposed(by: bag)
    }
    
    
    func getCoolerClosets(closetId: Int, page: Int) {
        closetDetailDataSource.getCoolerCloset(closetId: closetId, page: page)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    if let firstRow  = dataList.firstRow,
                       let secondRow = dataList.secondRow {
                        owner.coolFirstRowInfo.accept(firstRow)
                        owner.coolSecondRowInfo.accept(secondRow)
                    }
                }).disposed(by: bag)
    }
}
