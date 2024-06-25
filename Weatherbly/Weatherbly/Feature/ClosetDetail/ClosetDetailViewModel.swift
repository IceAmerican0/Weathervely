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
    public var detailViewSections = BehaviorRelay<[DetailViewSectionModel]>(value: [.mainDetail(items: [])])
    
    /// 선택된 옷 정보
    private var mainDetailSection = BehaviorRelay<DetailViewSectionModel?>(value: .mainDetail(items: []))
    public var selectedClosetInfo = BehaviorRelay<SelectedClosetInfo?>(value: nil)
    
    
    /// 함께착용한 아이템 정보
    private var withItemSection = BehaviorRelay<DetailViewSectionModel?>(value: .withItem(items: []))
    public var withItemSectionItem = BehaviorRelay<[DetailSectionItem]?>(value: nil)
    
    /// Warmmer closets
    public var warmFirstSection = BehaviorRelay<DetailViewSectionModel?>(value: .warmFirst(items: []))
    public var warmFirstRowInfo = BehaviorRelay<Rows?>(value: nil)
    
    public var warmSecondSection = BehaviorRelay<DetailViewSectionModel?>(value: .warmSecond(items: []))
    public var warmSecondRowInfo = BehaviorRelay<Rows?>(value: nil)
    
    /// Cooler losets
    public var coolFirstSection = BehaviorRelay<DetailViewSectionModel?>(value: .coolFirst(items: []))
    public var coolFirstRowInfo = BehaviorRelay<Rows?>(value: nil)
    
    public var coolSecondSection = BehaviorRelay<DetailViewSectionModel?>(value: .coolSecond(items: []))
    public var coolSecondRowInfo = BehaviorRelay<Rows?>(value: nil)
    let closetId: Int
    
    init(closetId: Int) {
        self.closetId = closetId
        super.init()
    }
    
    public func fetchData() {
        bindDiffTemSection()
        getClosetDetail(closetId: closetId)
        getWarmmerClosets(closetId: closetId, page: 1)
        getCoolerClosets(closetId: closetId, page: 1)
    }
    
    public func bindDiffTemSection() {
           
        Observable.combineLatest(mainDetailSection, withItemSection, warmFirstSection, warmSecondSection, coolFirstSection, coolSecondSection).map { mainDetail, withItem, warmFirst, warmSecond, coolFirst, coolSecond -> [DetailViewSectionModel] in
            var sections: [DetailViewSectionModel] = [mainDetail!,
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

    public func getClosetDetail(closetId: Int) {
        closetDetailDataSource.getClosetDetail(closetId: closetId)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    print("response : \(response)")
                    guard let data = response.data else { return }
                    print("data : \(data)")
                    if let detailInfo = data.selectedCloset,
                       let withItemInfo = detailInfo.withItems {
                        
                        // detailSection accept
                        let detailArray: [DetailSectionItem] = [DetailSectionItem.mainDetail(detailInfo)]
                        owner.mainDetailSection.accept(.mainDetail(items: detailArray))
                        
                        // withItemSectio accept
                        var itemArray: [DetailSectionItem] = []
                        withItemInfo.map {
                            itemArray.append(DetailSectionItem.withItem($0))
                        }
                
                        owner.withItemSectionItem.accept(itemArray)
                        owner.withItemSection.accept(.withItem(items: itemArray))
                    }
                })
            .disposed(by: bag)
    }
    
    public func getWarmmerClosets(closetId: Int, page: Int) {
        closetDetailDataSource.getWarmmerCloset(closetId: closetId, page: 1)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    if let firstRow  = dataList.firstRow {
                        var firstItems: [DetailSectionItem] = []
                        firstRow.closets.map { firstItems.append(DetailSectionItem.firstRow($0))}
                        owner.warmFirstSection.accept(.warmFirst(items: firstItems))
                        //                        owner.warmFirstRowInfo.accept(firstRow)
                    }
                    if let secondRow = dataList.secondRow {
                        var secondItems: [DetailSectionItem] = []
                        secondRow.closets.map {
                            secondItems.append(DetailSectionItem.secondRow($0))
                        }
                        owner.warmSecondSection.accept(.warmSecond(items: secondItems))
//                        owner.warmSecondRowInfo.accept(secondRow)
                    }
                }).disposed(by: bag)
    }
    
    
    public func getCoolerClosets(closetId: Int, page: Int) {
        closetDetailDataSource.getCoolerCloset(closetId: closetId, page: 1)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    if let firstRow  = dataList.firstRow {
                        var firstItems: [DetailSectionItem] = []
                        firstRow.closets.map { firstItems.append(DetailSectionItem.firstRow($0))}
                        owner.coolFirstSection.accept(.coolFirst(items: firstItems))
                        owner.coolFirstRowInfo.accept(firstRow)
                    }
                    if let secondRow = dataList.secondRow {
                        var secondItems: [DetailSectionItem] = []
                        secondRow.closets.map {
                            secondItems.append(DetailSectionItem.secondRow($0))
                        }
                        owner.coolSecondSection.accept(.coolSecond(items: secondItems))
                        owner.coolSecondRowInfo.accept(secondRow)
                    }
                }).disposed(by: bag)
    }
    
}
