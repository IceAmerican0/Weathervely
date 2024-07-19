//
//  HorizonCellViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/19/24.
//

import RxCocoa
import RxSwift

final class HorizonCellViewModel {

    // MARK: - API
    let dataSource = NewClosetDataSource()

    private var bag = DisposeBag()
    public let bindClosets = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    public let sectionItems = BehaviorRelay<[StyleTabItem]?>(value: nil)
    public var selectedTags = BehaviorRelay<[Int]>(value: [])
    public var categoriesRelay = BehaviorRelay<[MCategoryInfo]>(value: [
       MCategoryInfo(id: 28, name: "니트/스웨터"),
       MCategoryInfo(id: 31, name: "긴소매 티셔츠"),
       MCategoryInfo(id: 32, name: "셔츠/블라우스"),
       MCategoryInfo(id: 33, name: "피케/카라티셔츠"),
       MCategoryInfo(id: 34, name: "반소매 티셔츠"),
       MCategoryInfo(id: 35, name: "민소매 티셔츠"),
       MCategoryInfo(id: 37, name: "기타 상의")
   ])
    public var typeInfo = ClosetTypeInfo.init(id: 0, name: "")
    public var currentPage = 1
    public var maxPage = 1
    
    public func prefetchClosets(_ page: Int) {
        let categories = selectedTags.value
        debugPrint(#function, categories)
        let cgParam = getCategoryParam(with: categories)
        
        dataSource.closetWithCategory(typeID: typeInfo.id, page: page, items: cgParam)
            .subscribe(with: self) { owner, response in
                let newClosets = response.data.closets
                guard var curItems = owner.sectionItems.value else { return }
                
                curItems.append(contentsOf: newClosets.map { StyleTabItem.closets($0) })
                owner.sectionItems.accept(curItems)
                owner.bindClosets.accept([.closets(item: curItems)])
                
                
            }.disposed(by: bag)
    }
    
    public func getFilteredByCategories(with tags: [Int], _ completion: (([NewClosetInfo]) -> Void)?) {
        selectedTags.accept(tags)
        let typeInfo = typeInfo
        
        switch tags.isEmpty {
        case true:
            dataSource.getClosetWithType(typeID: typeInfo.id, page: 1)
                .subscribe(with: self) { owner, response in
                    let newClosets = response.data.closets
                    completion?(newClosets)
                }
                .disposed(by: bag)
            
        case  false:
            let cgParam = getCategoryParam(with: tags)
            dataSource.closetWithCategory(typeID: typeInfo.id, page: 1, items: cgParam)
                .subscribe(with: self) { owner, response in
                    let newClosets = response.data.closets
                    completion?(newClosets)
                }
                .disposed(by: bag)
        }
    }
    
    func getMaxPage() {
        // 해당 Cell에 데이터 들어오면 sectionItems에 바인딩.
        if let curItems = sectionItems.value {

            maxPage = calculateShare(curItems.count)
        }
    }
    
    func getCategoryParam(with tags: [Int]) -> String {
        var itemsString = ""
        for item in tags {
            if item == tags.last {
                itemsString += String(item) + ","
            } else {
                itemsString += String(item)
            }
        }
        return itemsString
    }

}

extension HorizonCellViewModel {
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
