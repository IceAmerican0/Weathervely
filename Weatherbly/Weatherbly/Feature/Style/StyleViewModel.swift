//
//  StyleViewModel.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol StyleViewModelLogic: ViewModelBusinessLogic {
    func getTypes()
}

final class StyleViewModel: RxBaseViewModel, StyleViewModelLogic {
    private let closetDataSource: NewClosetDataSource
    /// 스타일 콜렉션 뷰 정보
    public var bindSectionsRelay = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    /// banner
    public let bannserSection = BehaviorRelay<StyleTabSectionModel?>(value: .banner(item: [.banner(StyleBanner())]))
    /// Types
    public var types = BehaviorRelay<[ClosetTypeInfo]?>(value: [])
    public var typesSection = BehaviorRelay<StyleTabSectionModel?>(value: .types(header: []))
    /// Categories
    public var categories = BehaviorRelay<[MCategoryInfo]?>(value: [])
    
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
    
    init(closetDataSource: NewClosetDataSource) {
        self.closetDataSource = closetDataSource
    }
    
    public func fetchData() {
        getTypes()
        bindSections()
    }
    public func bindSections() {
        
        let combineBannerAndType = Observable.combineLatest(bannserSection, typesSection).map { banner, types -> [StyleTabSectionModel] in
            var sections: [StyleTabSectionModel] = []
            if let banner, let types {
                sections.append(banner)
                sections.append(types)
            }
            return sections
        }
        
        Observable.combineLatest(combineBannerAndType, styleSection).map { bannerAndTypes, styles -> [StyleTabSectionModel] in
            var sections = bannerAndTypes
            guard let styles = styles  else { return sections }
            sections.append(contentsOf: styles)
            return sections
        }
        .bind(to: bindSectionsRelay)
        .disposed(by: bag)
        
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
                let typeSection = StyleTabSectionModel.types(header: typeInfo)
                owner.typesSection.accept(typeSection)
                
                // StyleSection에 들어갈 데이터 바인딩
                let _ = typeInfo.map {
                    owner.getClosets(typeInfo: $0, page: 1)
                }
            })
            .disposed(by: bag)
    }
    
    public func getCategories(typeID: Int, _ completion: @escaping (([MCategoryInfo]) -> Void)) {
        closetDataSource.getCategories(typeID: typeID)
            .subscribe(with: self, onNext: { owner, response in
                let categories = response.data.mediumCategories
//                var categoriArr: [MCategoryInfo] = owner.categories.value ?? []
                owner.categories.accept(categories)
                completion(owner.categories.value ?? [])
            }).disposed(by: bag)
        
    }
    
    public func getClosets(typeInfo: ClosetTypeInfo, page: Int) {
        closetDataSource.getClosetWithType(typeID: typeInfo.id, page: 1)
            .subscribe(with: self, onNext: { owner, response in
                let closetsInfo = response.data.closets
                var styleSection = owner.styleSection.value ?? []
                
                var styleItemArr: [StyleTabItem] = []
                let _ = closetsInfo.map {
                    styleItemArr.append(StyleTabItem.styles($0))
                }
                styleSection.append(                    StyleTabSectionModel.styles(header: typeInfo, items: styleItemArr))
                owner.styleSection.accept(styleSection)
                
            })
            .disposed(by: bag)
    }
}



//        let mockClosetList: [StyleTabItem] = [.styles(StyleClosetInfo(id: 889, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37045_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 889, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37045_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 890, name: "개성 더하기", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_36771_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 891, name: "아메카지 감성", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_36502_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 892, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_36501_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 893, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_36493_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 894, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_35815_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 895, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_36082_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 896, name: "아메리칸 캐주얼", imageUrl:  "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_36081_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 897, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_32212_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 898, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37134_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active")),
//                        .styles(StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active"))]
//
