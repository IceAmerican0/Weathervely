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
    public var detailViewSections = BehaviorRelay<[DetailViewSectionModel]>(value: [.mainDetail(items: [.mainDetail(SelectedClosetInfo(id: 967, name: "완벽한 조합", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_chic_detail_37098_500.jpg", shopName: "무신사", style: SelectedClosetTypeInfo(typeId: 1, typeName: "")))])])
    
    /// 선택된 옷 정보
    public var selectedClosetInfo = BehaviorRelay<SelectedClosetInfo?>(value: SelectedClosetInfo(id: 967, name: "완벽한 조합", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_chic_detail_37098_500.jpg", shopName: "무신사", style: SelectedClosetTypeInfo(typeId: 1, typeName: "")))
    
    /// 함께착용한 아이템 정보
    public var withItemInfo = BehaviorRelay<[WithItemsInfo]?>(value: [WithItemsInfo(id: 1)])
    public var withItemSectionItem = BehaviorRelay<[DetailSectionItem]?>(value: [.withItem(WithItemsInfo(id: 1))])
    /// Warmmer closets
    public var warmListInfo = BehaviorRelay<DiffTempClosetList?>(value: DiffTempClosetList())
    public var warmFirstRowInfo = BehaviorRelay<Rows?>(value: Rows(counts: 10, closets: [RowInfo(closetId: 1, closetName: "", closetImageUrl: "", closetStatus: "")]))
    
    public var warmSecondRowInfo = BehaviorRelay<Rows?>(value: Rows(counts: 10, closets: [RowInfo(closetId: 1, closetName: "", closetImageUrl: "", closetStatus: "")]))
    public var warmmerSection = BehaviorRelay<[DetailViewSectionModel]>(value: [])
    
    /// Cooler losets
    public var coolListInfo = BehaviorRelay<DiffTempClosetList?>(value: DiffTempClosetList())
    public var coolFirstRowInfo = BehaviorRelay<Rows?>(value: Rows(counts: 10, closets: [RowInfo(closetId: 1, closetName: "", closetImageUrl: "", closetStatus: "")]))
    public var coolSecondRowInfo = BehaviorRelay<Rows?>(value: Rows(counts: 10, closets: [RowInfo(closetId: 1, closetName: "", closetImageUrl: "", closetStatus: "")]))
    public var coolerSection = BehaviorRelay<[DetailViewSectionModel]>(value: [])
    
    public func fetchData(_ completion: @escaping (() -> Void)) {
        getClosetDetail(closetId: testClosetId)
        getWarmmerClosets(closetId: testClosetId, page: 1)
        getCoolerClosets(closetId: testClosetId, page: 1)
        completion()
    }
    
    public func bindDiffTemSection() {
        
////        let warmSection = transformToSectionModel(warmListInfo: warmListInfo.value!)
//        var sections: [DetailViewSectionModel] = [
//            .mainDetail(items: [.mainDetail(self.selectedClosetInfo.value!)]),
//            .withItem(items: self.withItemSectionItem.value!),
////            .warmmer(items: warmSection)
//        ]
//
//        self.detailViewSections.accept(sections)
        
        Observable.combineLatest(warmFirstRowInfo, warmSecondRowInfo)
            .map { firstRow, secondRow -> [DetailViewSectionModel] in
                var items: [DetailSectionItem] = []
                if let firstRow = firstRow?.closets {
                    items.append(contentsOf: firstRow.map { .firstRow($0) })
                }
                if let secondRow = secondRow?.closets {
                    items.append(contentsOf: secondRow.map { .firstRow($0)})
                }
                return [.warmFirst(items: items)]
            }
            .bind(to: warmmerSection)
            .disposed(by: bag)
//        
        Observable.combineLatest(coolFirstRowInfo, coolSecondRowInfo)
            .map { firstRow, secondRow -> [DetailViewSectionModel] in
                var items: [DetailSectionItem] = []
                if let firstRow = firstRow?.closets {
                    items.append(contentsOf: firstRow.map { .secondRow($0) })
                }
                if let secondRow = secondRow?.closets {
                    items.append(contentsOf: secondRow.map { .secondRow($0) })
                }
                return [.coolFirst(items: items)]
            }
            .bind(to: coolerSection)
            .disposed(by: bag)
        
        
        Observable.combineLatest(warmmerSection, coolerSection)
            .map { warmSections, coolSections -> [DetailViewSectionModel] in
                var sections: [DetailViewSectionModel] = [
                    .mainDetail(items: [.mainDetail(self.selectedClosetInfo.value!)]),
                    .withItem(items: self.withItemSectionItem.value!)
                ]
                print("warSections : \n", warmSections)
                sections.append(contentsOf: warmSections)
                sections.append(contentsOf: coolSections)
                return sections
            }.bind(to: detailViewSections)
            .disposed(by: bag)

    }
    
    
    // FIXME: - Test variatio
    var testClosetId = 967
    public func getClosetDetail(closetId: Int) {
        closetDetailDataSource.getClosetDetail(closetId: testClosetId)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    print("response : \(response)")
                    guard let data = response.data else { return }
                    print("data : \(data)")
                    if let detailInfo = data.selectedCloset,
                       let withItemInfo = detailInfo.withItems {
                        owner.selectedClosetInfo.accept(detailInfo)
                        
                        var itemArray: [DetailSectionItem] = []
                        withItemInfo.map {
                            itemArray.append(DetailSectionItem.withItem($0))
                        }

                        owner.withItemSectionItem.accept(itemArray)
                        owner.withItemInfo.accept(withItemInfo)
                    }
                })
            .disposed(by: bag)
    }
    
    public func getWarmmerClosets(closetId: Int, page: Int) {
        closetDetailDataSource.getWarmmerCloset(closetId: testClosetId, page: 1)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let dataList = response.data?.list else { return }
                    if let firstRow  = dataList.firstRow,
                       let secondRow = dataList.secondRow {
                        owner.warmListInfo.accept(dataList)
                        owner.warmFirstRowInfo.accept(firstRow)
                        owner.warmSecondRowInfo.accept(secondRow)
                    }
                }).disposed(by: bag)
    }
    
    public func getCoolerClosets(closetId: Int, page: Int) {
        closetDetailDataSource.getCoolerCloset(closetId: testClosetId, page: 1)
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
    
    public func transformToSectionModel(warmListInfo: DiffTempClosetList) -> [DetailViewSectionModel] {
//        var items: [DetailSectionItem] = []
//
//        if let firstRow = warmListInfo.firstRow?.closets {
//            items.append(contentsOf: firstRow.map { DetailSectionItem.warmmer($0, rowType: .firstRow) })
//        }
//
//        if let secondRow = warmListInfo.secondRow?.closets {
//            items.append(contentsOf: secondRow.map { DetailSectionItem.warmmer($0, rowType: .secondRow) })
//        }
//
//        return [.warmmer(items: firstRowItems)]
        
        //
        // FIXME: - TestCode
        var firstRowItems: [DetailSectionItem] = []
           var secondRowItems: [DetailSectionItem] = []
           
           if let firstRow = warmListInfo.firstRow?.closets {
               firstRowItems.append(contentsOf: firstRow.map { DetailSectionItem.firstRow($0) })
           }
           
           if let secondRow = warmListInfo.secondRow?.closets {
               secondRowItems.append(contentsOf: secondRow.map { DetailSectionItem.firstRow($0) })
           }
           
           return [
               .warmFirst(items: firstRowItems),
               .warmFirst(items: secondRowItems)
           ]
    }
}
