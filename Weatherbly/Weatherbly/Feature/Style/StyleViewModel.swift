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
    public func filterCloset() {
        let vc = FilterListViewController(FilterListViewModel())
        presentViewControllerWithAnimationRelay.accept(vc)
    }
}
