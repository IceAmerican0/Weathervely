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
    func getAPISerial(with typeInfo: [ClosetTypeInfo], _ completion: (([StyleTabSectionModel]) -> Void)? )
    
    var shimmerStatus: PublishRelay<Bool> { get }
}

public final class StyleViewModel: RxBaseViewModel, StyleViewModelLogic {
    private let closetDataSource: ClosetDataSourceProtocol = ClosetDataSource()
    private let categoryDataSource: MediumCategoryDataSourceProtocol = MediumCategoryDataSource()
    /// 첫 실행 shimmer 여부
    public var shimmerStatus: PublishRelay<Bool> = .init()
    /// 스타일 콜렉션 뷰 정보
    public var bindSectionsRelay = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    /// banner
    public let bannserSection = BehaviorRelay<StyleTabSectionModel?>(value: .banner(item: [.banner(StyleBanner())]))
    /// Types
    public var types = BehaviorRelay<[ClosetTypeInfo]?>(value: [])
    public var typesSection = BehaviorRelay<StyleTabSectionModel?>(value: .types(header: [], items: []))
    /// Closets
    public var styleSection = BehaviorRelay<[StyleTabSectionModel]?>(value: [])
    
    /*
     // TODO: 필요한 데이터
     - 처음 들어왔을 때
     1. TypeSection Header에 들어갈 데이터 가지고 오기 -> [ClosetTypeInfo]
     2. 카테고리 API 호출 -> type 별 카테고리 데이터를 위한 데이터 가지고 있기
     [
     [MediumcategoryList for type 1],
     [MediumcategoryList for type 2],
     [MediumcategoryList for type 3], ...
     ]
     3. Closet API 호출 -> [StyleClosetInfo]
     
     - 바인딩 할 때
     1. [bannerSection,
     typeSection,
     StypeSection1 [ header: [MediumCategory for type1]
     */
    
    public func fetchData() {
        getTypes()
        bindSections()
    }
    
    public func bindSections() {
        let _  = Observable.combineLatest(bannserSection, typesSection).map { banner, types -> [StyleTabSectionModel] in
            var sections: [StyleTabSectionModel] = []
            if let banner, let types {
                sections.append(banner)
                sections.append(types)
            }
            return sections
        }.bind(to: bindSectionsRelay)
            .disposed(by: bag)
    }
    
    public func getTypes() {
        closetDataSource.getTypes()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let typeInfo = response.data.types
                    owner.types.accept(typeInfo)
                    // 섹션에서 선택값 들고 있는 것 초기화하기
                    let  _ = typeInfo.map {
                        userDefault.set([],forKey: String($0.id)) }
                    
                    owner.getAPISerial(with: typeInfo) { styleSections in
                        owner.typesSection.accept(.types(header: typeInfo, items: [.type(styleSections)]))
                        owner.shimmerStatus.accept(true)
                    }
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                }
            )
            .disposed(by: bag)
    }
    
    public func getCategories(typeID: Int) -> Observable<[StyleMediumCategoryInfo]> {
        return categoryDataSource.getStyleMediumCategoryList(id: typeID)
            .map { response in
                return response.data.mediumCategories
            }
    }
    
    public func getClosets(typeInfo: ClosetTypeInfo, categories: [StyleMediumCategoryInfo], page: Int) -> Observable<[ClosetInfo]>  {
        return closetDataSource.getClosetWithType(typeID: typeInfo.id, page: 1)
            .map { response in
                let closetInfo = response.data.closets
                return closetInfo
            }
    }
    
    public func getAPISerial(with typeInfo: [ClosetTypeInfo], _ completion: (([StyleTabSectionModel]) -> Void)?) {
        Observable.from(typeInfo)
            .concatMap { typeInfo in
                self.getCategories(typeID: typeInfo.id)
                    .map { categories in (typeInfo, categories) }
            }
            .concatMap { (typeInfo, categories) in
                self.getClosets(typeInfo: typeInfo, categories: categories, page: 1)
                    .map { closetsInfo in (typeInfo, categories, closetsInfo) }
            }
            .subscribe(onNext: { (typeInfo, categories, closetsInfo) in
                var styleSection = self.styleSection.value ?? []
                var styleItemArr: [StyleTabItem] = []

                // FIXED : StyleSectionModel 수정하면서 이미지 하나가 아니라 배열 자체를 넘길 예정
                closetsInfo.forEach {
                    styleItemArr.append(StyleTabItem.styles($0))
                }
                styleSection.append(
                    StyleTabSectionModel.styles(
                        header: (typeInfo: typeInfo, categories: categories),
                        items: styleItemArr)
                )
                
                self.styleSection.accept(styleSection)
                
            }, onError: { error in
                self.shimmerStatus.accept(true)
            }, onCompleted: {
                
                completion?(self.styleSection.value ?? [])
            })
            .disposed(by: bag)
    }

}
