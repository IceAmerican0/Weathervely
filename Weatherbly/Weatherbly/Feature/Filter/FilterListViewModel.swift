//
//  FilterListViewModel.swift
//  Weatherbly
//
//  Created by Khai on 1/16/24.
//

import UIKit
import RxCocoa

protocol FilterListViewModelLogic: ViewModelBusinessLogic {
    func filterStyleList()
    func filterItemList()
    
    var viewState: FilterListViewState { get }
    var filteredStyleList: PublishRelay<[FilterStyleListInfo]> { get }
    var filteredItemList: PublishRelay<[FilterItemListInfo]> { get }
    var filterSection: PublishRelay<[FilterSection]> { get }
}

final class FilterListViewModel: RxBaseViewModel, FilterListViewModelLogic {
    /// 현재 탭
    var viewState: FilterListViewState
    
    /// 스타일 리스트
    var filteredStyleList: PublishRelay<[FilterStyleListInfo]>
    
    /// 아이템 리스트
    var filteredItemList: PublishRelay<[FilterItemListInfo]>
    
    /// 필터 정보
    var filterSection: PublishRelay<[FilterSection]>
    
    init(viewState: FilterListViewState) {
        self.viewState = viewState
        self.filteredStyleList = .init()
        self.filteredItemList = .init()
        self.filterSection = .init()
        super.init()
    }
    
    /// 스타일 필터
    func filterStyleList() {
        
    }
    
    /// 아이템 필터
    func filterItemList() {
        
    }
}
