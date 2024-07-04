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
    var selectedTime: String
    /// 로딩 상태
    var isLoading = BehaviorRelay<Bool>(value: false)
    /// 선택된 아이템 리스트
    var selectedList = BehaviorRelay<[String]>(value: [])
    /// 필터 정보
    var filterSection = PublishRelay<[FilterSection]>()
    /// 코디 카운트
    var filterCount: PublishRelay<Int>
    
    public init(selectedTime: String) {
        self.selectedTime = selectedTime
        self.filterCount = .init()
        super.init()
        self.selectedList.accept(UserDefaultManager.shared.homeItemFilterList)
    }
    
    /// 아이템 리스트 가져오기
    public func getCategoryList() {
        if !isLoading.value {
            isLoading.accept(true)
        }
        
        let dataSource: MediumCategoryDataSourceProtocol = MediumCategoryDataSource()
        dataSource.getMainMediumCategoryList()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let data = response.data.mediumCategories
                    
                    let section: [FilterSection] = data.map {
                        .item(category: $0.category, items: $0.items.map { .item($0) } )
                    }
                    owner.filterSection.accept(section)
                    owner.getFilterCount()
                },
                onError: { owner, error in
                    owner.isLoading.accept(false)
                    owner.alertState.accept(
                        .init(
                            title: "리스트를 불러오지 못했어요",
                            alertType: .popup,
                            closeAction: {
                                self.dismissSelfWithAnimationRelay.accept(Void())
                            }
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 아이템 필터 구성
    public func getFilterCount(id: String? = nil) {
        if !isLoading.value {
            isLoading.accept(true)
        }
        
        var list = selectedList.value
        
        if let id {
            if let index = list.firstIndex(of: id) {
                list.remove(at: index)
            } else {
                list.append(id)
            }
        }
        
        if list != selectedList.value {
            selectedList.accept(list)
        }
        
        let dataSource: NewClosetDataSourceProtocol = NewClosetDataSource()
        dataSource.getFilterCount(list: list, time: selectedTime)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.isLoading.accept(false)
                    owner.filterCount.accept(response.data.counts)
                },
                onError: { owner, error in
                    owner.isLoading.accept(false)
                    owner.filterCount.accept(-1)
                }
            ).disposed(by: bag)
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
