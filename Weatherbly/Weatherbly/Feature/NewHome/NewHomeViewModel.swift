//
//  NewHomeViewModel.swift
//  Weatherbly
//
//  Created by Khai on 12/31/23.
//

import UIKit
import RxSwift
import RxCocoa

public protocol NewHomeViewModelLogic: ViewModelBusinessLogic {
    func loadHome()
    func pullToRefresh()
    func getForecastInfo()
    func getClosetInfo()
    func buttonTapAction(action: ButtonTapAction)
    func configureTime()
    func filterCloset()
    func toEditRegionView()
    func toTendaysForecastView()
    
    var refreshStatus: PublishRelay<Bool> { get }
    var homeSections: PublishRelay<[HomeSection]> { get }
    var homeForecastCellState: PublishRelay<[HomeForecastCellState]> { get }
}

public final class NewHomeViewModel: RxBaseViewModel, NewHomeViewModelLogic {
    private let closetDataSource: ClosetDataSourceProtocol
    
    /// 새로고침 상태
    public var refreshStatus: PublishRelay<Bool>
    
    /// 홈 전체 정보
    public var homeSections = PublishRelay<[HomeSection]>()
    
    /// 날씨 정보
    public var homeForecastCellState = PublishRelay<[HomeForecastCellState]>()
    
    /// 선택돼있는 날씨 정보
    var selectedForecastViewState: HomeForecastCellState
    
    /// 스타일 추천 리스트
    public var recommendedCloset = BehaviorRelay<RecommendClosetBody?>(value: nil)
    
    init(
        closetDataSource: ClosetDataSourceProtocol,
        homeForecastCellState: [HomeForecastCellState]
    ) {
        self.closetDataSource = closetDataSource
        self.refreshStatus = .init()
        self.homeForecastCellState.accept(homeForecastCellState)
        guard let cellState = homeForecastCellState.first else { fatalError() }
        self.selectedForecastViewState = cellState
        super.init()
        
        getClosetInfo()
    }
    
    /// 홈 전체 정보 취합 후 DataSource Reload
    public func loadHome() {
        let homeForecast: [HomeSection] = [
            .forecast(items: [.forecast(selectedForecastViewState)])
        ]
        
        guard let data = recommendedCloset.value else { return }
        let closet: [HomeSection] = [
            .closet(items: [.closet(data)])
        ]
        
        homeSections.accept((homeForecast + closet))
    }
    
    /// 새로고침
    public func pullToRefresh() {
        refreshStatus.accept(true)
        getForecastInfo()
    }
    
    /// 날씨 정보 받아오기
    public func getForecastInfo() {
        getClosetInfo()
    }
    
    /// 스타일 추천 리스트 받아오기
    public func getClosetInfo() {
        let dateString = Date().todayHourFormat
        closetDataSource.getRecommendCloset(dateString)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    guard let data = response.data else { return }
                    owner.recommendedCloset.accept(data.list)
                    owner.refreshStatus.accept(false)
                    owner.loadHome()
                },
                onError: { owner, error in
                    owner.refreshStatus.accept(false)
                    owner.alertMessageRelay.accept(.init(title: error.localizedDescription,
                                                         alertType: .Error,
                                                         closeAction: {
                        owner.navigationPopToSelfRelay.accept(Void())
                    }))
            })
            .disposed(by: bag)
    }
    
    /// 버튼 액션 케이스
    public func buttonTapAction(action: ButtonTapAction) {
        switch action {
        case .didTapPrev: configureTime()
        case .didTapNext: configureTime()
        case .didTapStyle: filterCloset()
        case .didTapItem: filterCloset()
        }
    }
    
    /// 시간대 이동 전 시간 판별
    public func configureTime() {
        
    }
    
    /// 필터링
    public func filterCloset() {
        
    }
    
    /// 10일간 날씨 예보 이동
    public func toTendaysForecastView() {
        let forecast = ForecastUseCase(forecastDataSource: ForecastDataSource())
        let vc = TenDaysForeCastViewController(TenDaysForecastViewModel(forecastUseCase: forecast))
        navigationPushViewControllerRelay.accept(vc)
    }
    
    /// 동네 설정 이동
    public func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel(.edit))
        navigationPushViewControllerRelay.accept(vc)
    }
}
