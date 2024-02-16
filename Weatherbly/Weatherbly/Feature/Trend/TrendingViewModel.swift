//
//  TrendingViewModel.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol TrendingViewModelLogic: ViewModelBusinessLogic {
    func getRecommendCloset()
}

final class TrendingViewModel: RxBaseViewModel, TrendingViewModelLogic {
    let recommendClosetEntityRelay = BehaviorRelay<[RecommendClosetInfo]>(value: [])
    
    public func getRecommendCloset() {
        let getClosetDataSource = ClosetDataSource()
        getClosetDataSource.getRecommendCloset(Date().todayHourFormat)
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
}
