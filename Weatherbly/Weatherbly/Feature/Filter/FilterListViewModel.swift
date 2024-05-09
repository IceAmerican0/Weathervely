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
    func filterItemList()
    
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
    
    override init() {
        self.isLoading = .init()
        self.isFiltered = .init()
        self.filterCount = .init()
        super.init()
    }
    
    /// 아이템 필터
    func filterItemList() {
        // TODO: delete mock
        let dummy: [FilterItemList] = [
            .init(
                category: "아우터",
                info: [
                    .init(id: 0, title: "자켓", selectable: true, selected: true),
                    .init(id: 0, title: "가디건", selectable: true, selected: false),
                    .init(id: 0, title: "집업", selectable: false, selected: false),
                ]
            ),
            .init(
                category: "상의",
                info: [
                    .init(id: 0, title: "티셔츠", selectable: false, selected: false),
                    .init(id: 0, title: "셔츠", selectable: false, selected: false),
                    .init(id: 0, title: "블라우스", selectable: true, selected: false),
                    .init(id: 0, title: "맨투맨", selectable: false, selected: false),
                    .init(id: 0, title: "니트", selectable: false, selected: false),
                ]
            ),
            .init(
                category: "하의",
                info: [
                    .init(id: 0, title: "청바지", selectable: false, selected: false),
                    .init(id: 0, title: "슬랙스", selectable: false, selected: false),
                    .init(id: 0, title: "치마", selectable: true, selected: false),
                ]
            )
        ]
        setItemSection(data: dummy)
    }
    
    /// 아이템 필터 구성
    func setItemSection(data: [FilterItemList]) {
        // TODO: delete mock
        let randomCount = Int.random(in: 1 ... 100)
        let itemSection: [FilterSection] = data.map {
            .item(
                category: $0.category,
                items: $0.info.map { .item($0) }
            )
        }
        filterSection.accept(itemSection)
        filterCount.accept(randomCount)
    }
}
