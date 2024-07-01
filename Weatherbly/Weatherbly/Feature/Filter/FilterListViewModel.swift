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
    func getFilterCount(id: String?)
    func reset()
    func filterCompleted()
    
    var isLoading: BehaviorRelay<Bool> { get }
    var selectedList: BehaviorRelay<[String]> { get }
    var filterSection: PublishRelay<[FilterSection]> { get }
    var filterCount: PublishRelay<Int> { get }
}

final class FilterListViewModel: RxBaseViewModel, FilterListViewModelLogic {
    /// 로딩 상태
    var isLoading = BehaviorRelay<Bool>(value: false)
    /// 선택된 아이템 리스트
    var selectedList = BehaviorRelay<[String]>(value: [])
    /// 필터 정보
    var filterSection = PublishRelay<[FilterSection]>()
    /// 코디 카운트
    var filterCount: PublishRelay<Int>
    
    override init() {
        self.filterCount = .init()
        super.init()
        self.selectedList.accept(UserDefaultManager.shared.homeItemFilterList)
    }
    
    /// 아이템 리스트 가져오기
    public func getCategoryList() {
        isLoading.accept(true)
        let dummy: [MediumCategoryList] = [
            .init(
                category: "아우터",
                items: [
                    .init(id: 1, name: "자켓"),
                    .init(id: 2, name: "가디건"),
                    .init(id: 3, name: "집업")
                ]
            ),
            .init(
                category: "상의",
                items: [
                    .init(id: 4, name: "티셔츠"),
                    .init(id: 5, name: "셔츠"),
                    .init(id: 6, name: "블라우스"),
                    .init(id: 7, name: "맨투맨"),
                    .init(id: 8, name: "니트")
                ]
            ),
            .init(
                category: "하의",
                items: [
                    .init(id: 9, name: "청바지"),
                    .init(id: 10, name: "슬랙스"),
                    .init(id: 11, name: "치마")
                ]
            )
        ]
        
        let itemSection: [FilterSection] = dummy.map {
            .item(
                category: $0.category,
                items: $0.items.map { .item($0) }
            )
        }
        filterSection.accept(itemSection)
        filterCount.accept(selectedList.value.count)
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
    public func getFilterCount(id: String? = nil) {
        isLoading.accept(true)
        
        var list = selectedList.value
        
        if let id {
            if let index = list.firstIndex(of: id) {
                list.remove(at: index)
            } else {
                list.append(id)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.isLoading.accept(false)
            self.selectedList.accept(list)
            self.filterCount.accept(list.count)
        }
        
//        let dataSource: FilteredStyleDataSourceProtocol = FilteredStyleDataSource()
//        dataSource.getFilteredStyleCount(id: list)
//            .subscribe(
//                with: self,
//                onNext: { owner, response in
//                    owner.isLoading.accept(false)
//                    owner.selectedList.accept(list)
//                    owner.filterCount.accept(response.data.count)
//                },
//                onError: { owner, error in
//                    owner.isLoading.accept(false)
//                    owner.filterCount.accept(-1)
//                }
//            ).disposed(by: bag)
    }
    
    public func reset() {
        selectedList.accept([])
        getFilterCount()
    }
    
    /// 필터 완료
    public func filterCompleted() {
        userDefault.set(selectedList.value, forKey: UserDefaultKey.homeItemFilterList.rawValue)
    }
}
