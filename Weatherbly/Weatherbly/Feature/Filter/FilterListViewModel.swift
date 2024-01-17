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
    func filterStyleList()
    func filterItemList()
    
    var viewState: FilterListViewState { get }
    var filterSection: PublishRelay<[FilterSection]> { get }
}

final class FilterListViewModel: RxBaseViewModel, FilterListViewModelLogic {
    /// 현재 탭
    var viewState: FilterListViewState
    
    /// 필터 정보
    var filterSection = PublishRelay<[FilterSection]>()
    
    init(viewState: FilterListViewState) {
        self.viewState = viewState
        super.init()
        
        switch viewState {
        case .style: filterStyleList()
        case .item: filterItemList()
        }
    }
    
    /// 스타일 필터
    func filterStyleList() {
        let dummy: [FilterStyleListInfo] = [
            .init(id: 0, title: "캐주얼", selected: false),
            .init(id: 0, title: "비즈니스캐주얼", selected: true),
            .init(id: 0, title: "아메카지", selected: false),
            .init(id: 0, title: "레트로", selected: false),
            .init(id: 0, title: "겁나멋있는", selected: true),
            .init(id: 0, title: "제멋대로", selected: false),
            .init(id: 0, title: "스트릿", selected: false),
        ]
        setStyleSection(data: dummy)
    }
    
    func setStyleSection(data: [FilterStyleListInfo]) {
        let randomCount = Int.random(in: 1 ... 100)
        let styleSection: [FilterSection] = [
            .style(items: data.map { .style($0) })
        ]
        print(styleSection)
        filterSection.accept(styleSection)
    }
    
    /// 아이템 필터
    func filterItemList() {
        let dummy: [FilterItemList] = [
        ]
        setItemSection(data: dummy)
    }
    
    func setItemSection(data: [FilterItemList]) {
//        let itemSection: [FilterSection] = data.map {
//            .cloth(
//                category: $0.category,
//                items: $0.info.map { [weak self] in
//                    let 
//                }
//            )
//        }
        let itemSection: [FilterSection] = []
        print(itemSection)
        filterSection.accept(itemSection)
    }
}
