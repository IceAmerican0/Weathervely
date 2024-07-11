//
//  NewStyleVM.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate protocol StyleViewModelLogic: ViewModelBusinessLogic {
    func getTypes()
}

final class NewStyleViewModel: RxBaseViewModel, StyleViewModelLogic {
    private let closetDataSource: NewClosetDataSource
    /// 스타일 콜렉션 뷰 정보
    public var bindSectionsRelay = BehaviorRelay<[NewStyleTabSectionModel]>(value: [])
    /// banner
    public let bannserSection = BehaviorRelay<NewStyleTabSectionModel?>(value: .banner(item: [.banner(StyleBanner())]))
    /// Types
    public var types = BehaviorRelay<[ClosetTypeInfo]?>(value: [])
    public var typesSection = BehaviorRelay<NewStyleTabSectionModel?>(value: .types(header: [.init(id: 0, name: "")], items: [.banner(StyleBanner())]))
    /// Categories
    public var categories = BehaviorRelay<[MCategoryInfo]?>(value: [])
    
    /// Closets
    public var styleSection = BehaviorRelay<[NewStyleTabSectionModel]?>(value: [])
    
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
    
    init(closetDataSource: NewClosetDataSource) {
        self.closetDataSource = closetDataSource
    }
    
    public func fetchData() {
        getTypes()
        bindSections()
    }
    public func bindSections() {
            // TODO: - bindine 되는지 체크하기
        /*
            // TODO: - bindSectionsRelay 의 모습은
            [
                .banner(bannerImage),
                .types( header: self.types.value, ( [ClosetTypeInfo] )
                        items: self.styleSectinos.value
                            ** 예시
                                [ .style(header: [MCategories], items: [NewClosetInfo,
                                    .style(header: [MCategories], items: [NewClosetInfo,
                                    .style(header: [MCategories], items: [NewClosetInfo,
                                    .style(header: [MCategories], items: [NewClosetInfo
         
                                    ]
            ]
         
         */
        
        
        let combineBannerAndType = Observable.combineLatest(bannserSection, typesSection).map { banner, types -> [NewStyleTabSectionModel] in
            var sections: [NewStyleTabSectionModel] = []
            if let banner, let types {
                sections.append(banner)
                //                sections.append(types)
            }
            debugPrint("bindingSection : \(sections) ")
            return sections
        }.bind(to: bindSectionsRelay)
            .disposed(by: bag)
        
        //        Observable.combineLatest(combineBannerAndType, styleSection).map { bannerAndTypes, styles -> [NewStyleTabSectionModel] in
        //            var sections = bannerAndTypes
        //            guard let styles = styles  else { return sections }
        //            sections.append(contentsOf: styles)
        //            return sections
        //        }
        //        .bind(to: bindSectionsRelay)
        //        .disposed(by: bag)
        //
        //        let bannerSection = StyleTabSectionModel.banner(item: [.banner(StyleBanner())])
        //        print("typesSections", typesSection.value)
        //        self.bindSectionsRelay.accept([bannerSection, typesSection.value!])
    }
    public func setMockDataSetup() {
        // "#비즈니스 캐주얼", "#캐주얼", "#시크", "#걸리시", "#레트로","#로맨틱", "#스트릿"
        let mockBannerList: [StyleTabItem] = [.banner(StyleBanner())]
    }
    
    public func getTypes() {
        closetDataSource.getTypes()
            .subscribe(with: self, onNext: { owner, response in
                let typeInfo = response.data.types
                owner.types.accept(typeInfo)
                //                let typeSection = NewStyleTabSectionModel.types(header: typeInfo, items: [])
                //                owner.typesSection.accept(typeSection)
                owner.getAPISerial(with: typeInfo)
            })
            .disposed(by: bag)
    }
    
    private func getAPISerial(with typeInfo: [ClosetTypeInfo]) {
        debugPrint("1️⃣1️⃣1️⃣ getCategories TYPEINFO : ", typeInfo)
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
                var styleItemArr: [NewStyleTabItem] = []
                closetsInfo.forEach {
                    styleItemArr.append(NewStyleTabItem.styles($0))
                }
                
                styleSection.append(
                    NewStyleTabSectionModel.styles(
                        header: (typeInfo: typeInfo, categories: categories),
                        items: styleItemArr)
                )
                
                self.styleSection.accept(styleSection)
            })
            .disposed(by: bag)
    }
    
    public func getCategories(typeID: Int) -> Observable<[MCategoryInfo]> {
        return closetDataSource.getCategories(typeID: typeID)
            .map { response in
                let categories = response.data.mediumCategories
                debugPrint("⚪️⚪️⚪️ getCategories TYPEINFO : ", typeID)
                return categories
            }
    }
    
    public func getClosets(typeInfo: ClosetTypeInfo, categories: [MCategoryInfo], page: Int) -> Observable<[NewClosetInfo]>  {
        return closetDataSource.getClosetWithType(typeID: typeInfo.id, page: 1)
            .map { response in
                let closetInfo = response.data.closets
                debugPrint("🔥🔥🔥 getClosets TYPEINFO : \(typeInfo.id) : \(typeInfo.name)")
                return closetInfo
            }
        //            .subscribe(with: self, onNext: { owner, response in
        //                let closetsInfo = response.data.closets
        //                var styleSection = owner.styleSection.value ?? []
        //
        //                var styleItemArr: [NewStyleTabItem] = []
        //                closetsInfo.forEach {
        //                    styleItemArr.append(NewStyleTabItem.styles($0))
        //                }
        //
        ////                styleSection.append(
        ////                    NewStyleTabSectionModel.styles(
        ////                        header: (typeInfo: typeInfo, categories: categories),
        ////                        items: styleItemArr)
        ////                )
        ////
        ////                owner.styleSection.accept(styleSection)
        //            })
        //            .disposed(by: bag)
    }
    
}
