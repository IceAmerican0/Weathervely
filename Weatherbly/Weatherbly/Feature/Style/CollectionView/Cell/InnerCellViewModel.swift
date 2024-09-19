//
//  InnerCellViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/21/24.
//

import RxDataSources
import RxCocoa
import RxSwift

public final class InnerCellViewModel {
    private var bag = DisposeBag()
    public let bindSectionsRelay = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    public let sectionItems = BehaviorRelay<[StyleTabItem]?>(value: nil)
    private let dataSource = ClosetDataSource()
    
    public func getFilteredByCategories(with tags: [Int] ,in sectionIndex: Int, typeInfo: ClosetTypeInfo) {
        switch tags.isEmpty {
        case true:
            dataSource.getClosetWithType(typeID: typeInfo.id, page: 1)
                .subscribe(with: self) { owner, response in
                    let newClosets = response.data.closets
                    let newItems: [StyleTabItem] = newClosets.map { .styles($0) }
                    var updatedSections = self.bindSectionsRelay.value
                    if sectionIndex < updatedSections.count {
                        if case .styles(let header, _) = updatedSections[sectionIndex] {
                            updatedSections[sectionIndex] = .styles(header: header, items: newItems)
                            self.bindSectionsRelay.accept(updatedSections)
                        }
                    }
                    
                }
                .disposed(by: bag)
            
        case  false:
            let cgParam = getCategoryParam(with: tags)
            dataSource.closetWithCategory(typeID: typeInfo.id, page: 1, items: cgParam)
                .subscribe(with: self) { owner, response in
                    let newClosets = response.data.closets
                    let newItems: [StyleTabItem] = newClosets.map { .styles($0) }
                    var updatedSections = self.bindSectionsRelay.value
                    if sectionIndex < updatedSections.count {
                        if case .styles(let header, _) = updatedSections[sectionIndex] {
                            updatedSections[sectionIndex] = .styles(header: header, items: newItems)
                            self.bindSectionsRelay.accept(updatedSections)
                        }
                    }
                }
                .disposed(by: bag)
        }
    }
    
    
    func getCategoryParam(with tags: [Int]) -> String {
        var itemsString = ""
        for item in tags {
            if item != tags.last {
                itemsString += String(item) + ","
            } else {
                itemsString += String(item)
            }
        }
        return itemsString
    }
    
    //    func getMaxPage() {
    //        // 해당 Cell에 데이터 들어오면 sectionItems에 바인딩.
    //        if let curItems = sectionItems.value {
    //
    //            maxPage = calculateShare(curItems.count)
    //        }
    //    }
}
