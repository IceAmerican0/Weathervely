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
    
    var dataSource: BehaviorRelay<[StyleSection]> { get }
    var shimmerStatus: PublishRelay<Bool> { get }
}

public final class StyleViewModel: RxBaseViewModel, StyleViewModelLogic {
    private let closetDataSource: ClosetDataSourceProtocol = ClosetDataSource()
    private let categoryDataSource: MediumCategoryDataSourceProtocol = MediumCategoryDataSource()
    /// 첫 실행 shimmer 여부
    public var shimmerStatus: PublishRelay<Bool> = .init()
    /// 스타일 콜렉션 뷰 정보
    public var dataSource = BehaviorRelay<[StyleSection]>(value: [])
    /// Types
    public var types: StyleSection = .tag(types: [])
    
    private var content: [StyleSection] = []
    
    public func fetchData() {
        getTypes()
    }
    
    public func getTypes() {
        closetDataSource.getTypes()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let typeInfo = response.data.types
                    owner.types = .tag(types: typeInfo)
                    // 섹션에서 선택값 들고 있는 것 초기화하기
                    let  _ = typeInfo.map {
                        userDefault.set([],forKey: String($0.id))
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
    
    public func getClosets(typeInfo: CategoryInfo, categories: [CategoryInfo], page: Int) -> Observable<[ClosetInfo]>  {
        return closetDataSource.getClosetWithType(typeID: typeInfo.id, page: 1)
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
                self.getClosets(typeInfo: typeInfo, categories: categories, page: 1)
                    .map { closetsInfo in (typeInfo, categories, closetsInfo) }
            }
            .subscribe(
                onNext: { [weak self] (typeInfo, categories, closetsInfo) in
                    guard let self else { return }
                    
                    self.content.append(.title(type: typeInfo.name))
                    self.content.append(.category(types: categories))
                    self.content.append(.card(item: closetsInfo))
                },
                onError: { error in
                    self.shimmerStatus.accept(true)
                },
                onCompleted: { [weak self] in
                    guard let self else { return }
                    
                    self.content.insert(self.types, at: 0)
                    self.content.insert(.banner, at: 0)
                    
                    self.dataSource.accept(self.content)
                    self.shimmerStatus.accept(true)
                }
            ).disposed(by: bag)
    }

}
