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
    
    private let detailDataSource = DetailDataSource()
    
    /// 첫 실행 shimmer 여부
    public var shimmerStatus: PublishRelay<Bool> = .init()
    
    /// 전체 CollectionView
    public var detailViewSections = BehaviorRelay<[DetailViewSectionModel]>(value: [.mainDetail(items: [])])
    
    /// 선택된 옷 정보
    private var mainDetailSection = BehaviorRelay<DetailViewSectionModel?>(value: .mainDetail(items: []))
    public var selectedClosetInfo = BehaviorRelay<SelectedClosetInfo?>(value: nil)
    
    /// 함께착용한 아이템 정보
    private var withItemSection = BehaviorRelay<DetailViewSectionModel?>(value: .withItem(items: []))
    public var withItemSectionItem = BehaviorRelay<[DetailSectionItem]?>(value: nil)
    
    /// Warmmer closets
    /// /// 더 따뜻한 옷 첫번쨰 줄
    public var warmFirstSection = BehaviorRelay<DetailViewSectionModel?>(value: .warmFirst(items: []))
    /// Section Item
    public var warmFirstRowInfo = BehaviorRelay<[DetailSectionItem]?>(value: nil)
    public var WFMaxPage = 1
    public var WFCurrentPage = 1

    /// 더 따뜻한 옷 두번째 줄
    public var warmSecondSection = BehaviorRelay<DetailViewSectionModel?>(value: .warmSecond(items: []))
    /// Section Item
    public var warmSecondRowInfo = BehaviorRelay<[DetailSectionItem]?>(value: nil)
    public var WSMaxPage = 1
    public var WSCurrentPage = 1
    
    /// Cooler closets
    public var coolFirstSection = BehaviorRelay<DetailViewSectionModel?>(value: .coolFirst(items: []))
    public var coolFirstRowInfo = BehaviorRelay<[DetailSectionItem]?>(value: nil)
    public var CFMaxPage = 1
    public var CFCurrentPage = 1
    
    public var coolSecondSection = BehaviorRelay<DetailViewSectionModel?>(value: .coolSecond(items: []))
    public var coolSecondRowInfo = BehaviorRelay<[DetailSectionItem]?>(value: nil)
    public var CSMaxPage = 1
    public var CSCurrentPage = 1
    
    let closetId: Int
    let tempId: Int
    
    init(closetId: Int, tempId: Int) {
        self.closetId = closetId
        self.tempId =  tempId
        super.init()
    }
    
    public func fetchData() {
        bindDiffTemSection()
        getClosetDetail(closetId: closetId, tempId: tempId)
        getWarmmerClosets(closetId: closetId, page: 1, tempId: tempId)
        getCoolerClosets(closetId: closetId, page: 1, tempId: tempId)
        
    }
    
    public func bindDiffTemSection() {
           
        Observable.combineLatest(mainDetailSection, withItemSection, warmFirstSection, warmSecondSection, coolFirstSection, coolSecondSection).map { mainDetail, withItem, warmFirst, warmSecond, coolFirst, coolSecond -> [DetailViewSectionModel] in
            let sections: [DetailViewSectionModel] = [mainDetail!,
                                                      withItem!,
                                                      warmFirst!,
                                                      warmSecond!,
                                                      coolFirst!,
                                                      coolSecond!
            ]
            return sections
        }
        .bind(to: detailViewSections)
            .disposed(by: bag)

    }

    public func getClosetDetail(closetId: Int, tempId: Int) {
        detailDataSource.getClosetDetail(closetId: closetId, tempId: tempId)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let data = response.data else { return }
                    if let detailInfo = data.selectedCloset,
                       let withItemInfo = detailInfo.withItems {
                        
                        // detailSection accept
                        let detailArray: [DetailSectionItem] = [DetailSectionItem.mainDetail(detailInfo)]
                        owner.mainDetailSection.accept(.mainDetail(items: detailArray))
                        
                        // withItemSectio accept
                        var itemArray: [DetailSectionItem] = []
                        let _ = withItemInfo.map {
                            itemArray.append(DetailSectionItem.withItem($0))
                        }
                
                        owner.withItemSectionItem.accept(itemArray)
                        owner.withItemSection.accept(.withItem(items: itemArray))
                    }
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                }).disposed(by: bag)
    }
    
    public func getWarmmerClosets(closetId: Int, page: Int, tempId: Int) {
        detailDataSource.getWarmmerCloset(closetId: closetId, page: page, tempId: tempId)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    
                    if let firstRow  = dataList.firstRow {
                        
                        var firstItems: [DetailSectionItem] = []
                        
                        let _ = firstRow.closets?.map { firstItems.append(DetailSectionItem.firstRow($0))}
                        owner.warmFirstRowInfo.accept(firstItems)
                        owner.warmFirstSection.accept(.warmFirst(items: firstItems))
                        owner.WFMaxPage = owner.calculateShare(firstRow.counts ?? 0)
                    }
                    
                    if let secondRow = dataList.secondRow {
                        
                        var secondItems: [DetailSectionItem] = []
                        
                        let _ = secondRow.closets?.map {
                            secondItems.append(DetailSectionItem.secondRow($0))
                        }
                        owner.warmSecondRowInfo.accept(secondItems)
                        owner.warmSecondSection.accept(.warmSecond(items: secondItems))
                        owner.WSMaxPage = owner.calculateShare(secondRow.counts ?? 0)
                    }
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                }).disposed(by: bag)
    }
    
    public func warmRowPrefetch(_ page: Int, rowId: Int) {
        detailDataSource.getWarmRowItems(closetId: closetId, page: page, tempId: tempId, row: rowId)
            .subscribe(with: self, onNext: { owner, response in
                
                if let itemsToAdd = response.data?.closets {
                    if rowId == 1 {
                        var firstRow = owner.warmFirstRowInfo.value
                        firstRow?.append(contentsOf: itemsToAdd.map { DetailSectionItem.firstRow($0)})
                        
                        //binding
                        owner.warmFirstRowInfo.accept(firstRow)
                        owner.warmFirstSection.accept(.warmFirst(items: firstRow ?? owner.warmFirstRowInfo.value!))
                    } else if rowId == 2 {
                        var secondRow = owner.warmSecondRowInfo.value
                        secondRow?.append(contentsOf: itemsToAdd.map { DetailSectionItem.secondRow($0) })
                        
                        owner.warmSecondRowInfo.accept(secondRow)
                        owner.warmSecondSection.accept(.warmSecond(items: secondRow ?? owner.warmSecondRowInfo.value!))
                    }
                }
            }).disposed(by: bag)
    }
    
    
    
    public func getCoolerClosets(closetId: Int, page: Int, tempId: Int) {
        detailDataSource.getCoolerCloset(closetId: closetId, page: page, tempId: tempId)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    
                    if let firstRow  = dataList.firstRow {
                        
                        var firstItems: [DetailSectionItem] = []
                        let _ = firstRow.closets?.map { firstItems.append(DetailSectionItem.firstRow($0))}
                        owner.coolFirstRowInfo.accept(firstItems)
                        owner.coolFirstSection.accept(.coolFirst(items: firstItems))
                        owner.CFMaxPage = owner.calculateShare(firstRow.counts ?? 0)
                    }
                    
                    if let secondRow = dataList.secondRow {
                        var secondItems: [DetailSectionItem] = []
                        let _ = secondRow.closets?.map {
                            secondItems.append(DetailSectionItem.secondRow($0))
                        }
                        owner.coolSecondRowInfo.accept(secondItems)
                        owner.coolSecondSection.accept(.coolSecond(items: secondItems))
                        owner.CSMaxPage = owner.calculateShare(secondRow.counts ?? 0)
                    }
                    
                    owner.shimmerStatus.accept(true)
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                }).disposed(by: bag)
    }
    
    public func coolRowPrefetch(_ page: Int, rowId: Int) {
        detailDataSource.getCoolRowItems(closetId: closetId, page: page, tempId: tempId, row: rowId)
            .subscribe(with: self, onNext: { owner, response in
                if let itemsToAdd = response.data?.closets {
                    if rowId == 1 {
                        var firstRow = owner.coolFirstRowInfo.value
                        firstRow?.append(contentsOf: itemsToAdd.map { DetailSectionItem.firstRow($0)})
                        
                        //binding
                        owner.coolFirstRowInfo.accept(firstRow)
                        owner.coolFirstSection.accept(.coolFirst(items: firstRow ?? owner.coolFirstRowInfo.value!))
                    } else if rowId == 2 {
                        var secondRow = owner.coolSecondRowInfo.value
                        secondRow?.append(contentsOf: itemsToAdd.map { DetailSectionItem.secondRow($0) })
                        
                        owner.coolSecondRowInfo.accept(secondRow)
                        owner.coolSecondSection.accept(.coolSecond(items: secondRow ?? owner.coolSecondRowInfo.value!))
                    }
                }
                
            }).disposed(by: bag)
    }
    
    /// 상세보기 이동
    public func toDetailView(closetId: Int, tempId: Int) {
        let vc = ClosetDetailViewController(ClosetDetailViewModel(closetId: closetId, tempId: tempId))
        navigationPushViewControllerRelay.accept(vc)
    }
}

extension ClosetDetailViewModel {
    // page 계산
    func calculateShare(_ count: Int) -> Int {
        // 10 20 30 73
        var share = 1
        if count / 20 == 0 {
            return share
        } else {
            if count % 20 == 0 {
                share = count / 20
                return share
            } else {
                share = (count / 20) + 1
                return share
            }
        }
    }
}
