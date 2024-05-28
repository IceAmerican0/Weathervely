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
    func getRecommendCloset()
    var filteredStyle: Bool { get set }
    var filteredItem: Bool { get set }
}

final class StyleViewModel: RxBaseViewModel, StyleViewModelLogic {
    private let closetDataSource: ClosetDataSourceProtocol
    /// 스타일 콜렉션 뷰 정보
    public var styleSections = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    public var styleTags =  BehaviorRelay<[ClosetTypeInfo]>(value: [])
    /// 스타일 필터 여부
    public var filteredStyle: Bool
    /// 아이템 필터 여부
    public var filteredItem: Bool
    
    let recommendClosetEntityRelay = BehaviorRelay<[RecommendClosetInfo]>(value: [])
    
    
    
    init(closetDataSource: ClosetDataSourceProtocol) {
        self.closetDataSource = closetDataSource
        self.filteredStyle = .init()
        self.filteredItem = .init()
    }
    
    public func setMockDataSetup() {
        // "#비즈니스 캐주얼", "#캐주얼", "#시크", "#걸리시", "#레트로","#로맨틱", "#스트릿"
        let mockBannerList: [StyleTabItem] = [.banner(StyleBanner())]
        let mockHeaderList: [ClosetTypeInfo] = [
                                              ClosetTypeInfo(id: 7, name: "#비즈니스 캐주얼"),
                                              ClosetTypeInfo(id: 1, name: "#캐주얼"),
                                              ClosetTypeInfo(id: 14, name: "#시크"),
                                              ClosetTypeInfo(id: 12, name: "#걸리시"),
                                              ClosetTypeInfo(id: 15, name: "#레트로"),
                                              ClosetTypeInfo(id: 12, name: "#로맨틱"),
                                              ClosetTypeInfo(id: 11, name: "#스트릿")]
        
        let mockCellList: [StyleTabItem] = [.styles(ClosetTypeInfo(id: 7, name: "#비즈니스 캐주얼")),
                                              .styles(ClosetTypeInfo(id: 1, name: "#캐주얼")),
                                              .styles(ClosetTypeInfo(id: 14, name: "#시크")),
                                              .styles(ClosetTypeInfo(id: 12, name: "#걸리시")),
                                              .styles(ClosetTypeInfo(id: 15, name: "#레트로")),
                                              .styles(ClosetTypeInfo(id: 12, name: "#로맨틱")),
                                              .styles(ClosetTypeInfo(id: 11, name: "#스트릿"))]
        
        let mockBannerSection = StyleTabSectionModel.banner(item: mockBannerList)
        
        let mockClosetSection = StyleTabSectionModel.styles(header: mockHeaderList, items: mockCellList)
//        let mockStyleSection = StyleTabSectionModel.styles(items: mockHeaderList)
        // TODO: - 이미지 캐싱
        styleSections.accept([mockBannerSection, mockClosetSection])
    }
    
    public func getRecommendCloset() {
        closetDataSource.getRecommendCloset(Date().todayHourFormat)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let closets = response.data?.list.closets else { return }
                    var temp: [RecommendClosetInfo] = []
                    for _ in 0..<5 {
                        temp += closets
                    }
                    owner.recommendClosetEntityRelay.accept(temp)
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup,
                                                         closeAction: {
                        owner.navigationPopToSelfRelay.accept(Void())
                    }))
            })
            .disposed(by: bag)
    }
    
    /// 필터링
    public func filterCloset(state: FilterListViewState) {
        let vc = ClosetFilterViewController(ClosetFilterViewModel(viewState: state))
        presentViewControllerWithAnimationRelay.accept(vc)
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
