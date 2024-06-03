//
//  FilterListViewModel.swift
//  Weatherbly
//
//  Created by Khai on 1/16/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol FilterListViewModelLogic: ViewModelBusinessLogic {
    func getCategoryList()
    func getFilterCount(id: Int?)
    
    var isLoading: PublishRelay<Bool> { get }
    var isFiltered: PublishRelay<Bool> { get }
    var filterSection: PublishRelay<[FilterSection]> { get }
    var filterCount: PublishRelay<Int> { get }
}

final class FilterListViewModel: RxBaseViewModel, FilterListViewModelLogic {
    /// 로딩 상태
    var isLoading: PublishRelay<Bool>
    /// 필터 선택 여부
    var isFiltered: PublishRelay<Bool>
    /// 필터 정보
    var filterSection = PublishRelay<[FilterSection]>()
    /// 코디 카운트
    var filterCount: PublishRelay<Int>
    /// 선택된 아이템 리스트
    private var selectedList: [Int]
    
    override init() {
        self.isLoading = .init()
        self.isFiltered = .init()
        self.filterCount = .init()
        self.selectedList = UserDefaultManager.shared.homeItemFilterList
        super.init()
        self.isFiltered.accept(selectedList.isEmpty ? false : true)
    }
    
    /// 아이템 리스트 가져오기
    public func getCategoryList() {
        isLoading.accept(true)
        let dummy: [MediumCategoryList] = [
            .init(
                category: "아우터",
                items: [
                    .init(id: 0, name: "자켓"),
                    .init(id: 0, name: "가디건"),
                    .init(id: 0, name: "집업")
                ]
            ),
            .init(
                category: "상의",
                items: [
                    .init(id: 0, name: "티셔츠"),
                    .init(id: 0, name: "셔츠"),
                    .init(id: 0, name: "블라우스"),
                    .init(id: 0, name: "맨투맨"),
                    .init(id: 0, name: "니트")
                ]
            ),
            .init(
                category: "하의",
                items: [
                    .init(id: 0, name: "청바지"),
                    .init(id: 0, name: "슬랙스"),
                    .init(id: 0, name: "치마")
                ]
            )
        ]
        
        let randomCount = Int.random(in: 1 ... 100)
        let itemSection: [FilterSection] = dummy.map {
            .item(
                category: $0.category,
                items: $0.items.map { .item($0) }
            )
        }
        filterSection.accept(itemSection)
        filterCount.accept(randomCount)
        isLoading.accept(false)
//        let dataSource: MediumCategoryDataSourceProtocol = MediumCategoryDataSource()
//        dataSource.getMediumCategoryList(id: UserDefaultManager.shared.homeStyleFilterList)
//            .subscribe(
//                with: self,
//                onNext: { owner, response in
//                    owner.isLoading.accept(false)
//                    let list = response.data.mediumCategories
//                    let section: [FilterSection] = list.map {
//                        .item(category: $0.category, items: $0.items.map { .item($0) } )
//                    }
//                    owner.filterSection.accept(section)
//                },
//                onError: { owner, error in
//                    owner.isLoading.accept(false)
//                }
//            ).disposed(by: bag)
    }
    
    /// 아이템 필터 구성
    public func getFilterCount(id: Int? = nil) {
        isLoading.accept(true)
        selectedList += [id].compactMap { $0 }
        
//        let dataSource: FilteredStyleDataSourceProtocol = FilteredStyleDataSource()
//        dataSource.getFilteredStyledCount(id: selectedList)
//            .subscribe(
//                with: self,
//                onNext: { owner, response in
//                    owner.isLoading.accept(false)
//                    owner.filterCount.accept(response.data.count)
//                },
//                onError: { owner, error in
//                    owner.isLoading.accept(false)
//                    owner.filterCount.accept(-1)
//                }
//            ).disposed(by: bag)
    }
}
