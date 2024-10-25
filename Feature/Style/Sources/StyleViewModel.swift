//
//  NewStyleVM.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import UIKit
import RxSwift
import RxCocoa

public protocol StyleViewModelLogic: ViewModelBusinessLogic {
    func getTypes()
    func getAPISerial(with typeInfo: [CategoryInfo])
    func toDetailView(id: Int, temp: Int)
    
    var dataSource: PublishRelay<[StyleSection]> { get }
    var shimmerStatus: PublishRelay<Bool> { get }
}

public final class StyleViewModel: RxBaseViewModel, StyleViewModelLogic {
    private let closetDataSource: ClosetDataSourceProtocol = ClosetDataSource()
    private let categoryDataSource: MediumCategoryDataSourceProtocol = MediumCategoryDataSource()
    /// 첫 실행 shimmer 여부
    public var shimmerStatus: PublishRelay<Bool> = .init()
    /// 스타일 콜렉션 뷰 정보
    public var dataSource: PublishRelay<[StyleSection]> = .init()
    /// performBatch용 relay
    public var refreshList = BehaviorRelay<[StyleSection]>(value: [])
    /// Types
    public var types: [CategoryInfo] = []
    /// 전체 섹션 정보
    private var content: [StyleSection] = []
    /// prefetch를 위한 페이지 정보
    private var pageInfo: [Int: Int] = [:]
    /// 필터 카테고리 리스트
    public var typeList: [Int: [CategoryInfo]] = [:]
    /// 필터 정보
    public var categoryFilter: [Int: [String]] = [:]
    
    public func getTypes() {
        closetDataSource.getTypes()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let typeInfo = response.data.types
                    owner.types = typeInfo
                    
                    typeInfo.forEach { type in
                        owner.pageInfo[type.id] = 1
                        owner.categoryFilter[type.id] = []
                    }
                    
                    owner.getAPISerial(with: typeInfo)
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                }
            )
            .disposed(by: bag)
    }
    
    public func getCategories(typeID: Int) -> Observable<[CategoryInfo]> {
        return categoryDataSource.getStyleMediumCategoryList(id: typeID)
            .map { response in
                return response.data.mediumCategories
            }
    }
    
    public func getClosets(typeInfo: CategoryInfo, page: Int) -> Observable<[ClosetInfo]>  {
        return closetDataSource.getStyleCloset(typeID: typeInfo.id, page: 1, categories: [])
            .map { response in
                let closetInfo = response.data.closets
                return closetInfo
            }
    }
    
    public func getAPISerial(with typeInfo: [CategoryInfo]) {
        Observable.from(typeInfo)
            .concatMap { typeInfo in
                self.getCategories(typeID: typeInfo.id)
                    .map { categories in (typeInfo, categories) }
            }
            .concatMap { (typeInfo, categories) in
                self.getClosets(typeInfo: typeInfo, page: 1)
                    .map { closetsInfo in (typeInfo, categories, closetsInfo) }
            }
            .subscribe(
                onNext: { [weak self] (typeInfo, categories, closetsInfo) in
                    guard let self else { return }
                    
                    self.typeList[typeInfo.id] = categories
                    self.content.append(.title(type: typeInfo.name))
                    self.content.append(.category(types: categories))
                    self.content.append(.card(item: closetsInfo))
                },
                onError: { error in
                    self.shimmerStatus.accept(true)
                },
                onCompleted: { [weak self] in
                    guard let self else { return }
                    
                    self.content.insert(.tag(types: self.types), at: 0)
                    self.content.insert(.banner(item: [.banner]), at: 0)
                    
                    self.dataSource.accept(self.content)
                    self.shimmerStatus.accept(true)
                }
            ).disposed(by: bag)
    }
    
    public func getNextCloset(indexPath: IndexPath) {
        // row + (row + 2) * 2
        let path = (indexPath.section - 4) / 3
        
        if path < 0 || path * 10 > 0 { return }
        
        let id = types[path].id
        let currentPage = (pageInfo[id] ?? 1) + 1
        let categories = categoryFilter[id] ?? []
        
        closetDataSource.getStyleCloset(typeID: id, page: currentPage, categories: categories)
            .subscribe(
                with: self,
                onNext: { owner, result in
                    for (index, section) in owner.content.enumerated() {
                        if path == index {
                            if case .card(let item) = section {
                                var newItem = item
                                newItem.append(contentsOf: result.data.closets)
                                owner.content[path] = .card(item: newItem)
                                owner.dataSource.accept(owner.content)
                                
                                owner.pageInfo[path] = currentPage
                            }
                        }
                    }
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    public func getFilteredList(indexPath: IndexPath, selected: Int) {
        guard let row = indexPath.first else { return }
        let path = (row / 3) - 1
        let id = types[path].id
        var categories = categoryFilter[id] ?? []
        
        if let index = categories.firstIndex(of: "\(selected)") {
            categories.remove(at: index)
        } else {
            categories.append("\(selected)")
        }
        
        categoryFilter[id] = categories
        
        closetDataSource.getStyleCloset(typeID: id, page: 1, categories: categories)
            .subscribe(
                with: self,
                onNext: { owner, result in
                    for (index, section) in owner.content.enumerated() {
                        if (row + 1) == index {
                            if case .card = section {
                                owner.content[row + 1] = .card(item: result.data.closets)
                                owner.refreshList.accept(owner.content)
                            }
                        }
                    }
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
                    )
                }
            ).disposed(by: bag)
    }

    public func toDetailView(id: Int, temp: Int) {
        let viewModel = ClosetDetailViewModel(closetId: id, tempId: temp)
        let vc = ClosetDetailViewController(viewModel)
        navigationPushViewControllerRelay.accept(vc)
    }
}
