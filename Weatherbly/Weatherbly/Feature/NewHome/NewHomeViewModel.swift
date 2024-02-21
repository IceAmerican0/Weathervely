//
//  NewHomeViewModel.swift
//  Weatherbly
//
//  Created by Khai on 12/31/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

public protocol NewHomeViewModelLogic: ViewModelBusinessLogic {
    func loadHome()
    func pullToRefresh()
    func getForecastInfo()
    func getClosetInfo()
    func buttonTapAction(action: ButtonTapAction)
    func configureTime(direction: UISwipeGestureRecognizer.Direction)
    func getSelectedTimeInfo(direction: UISwipeGestureRecognizer.Direction)
    func didTapTimeLabel()
    func filterCloset(state: FilterListViewState)
    func toDetailView(state: NewClosetInfo)
    func toEditRegionView()
    func toNotificationListView()
    func toTendaysForecastView()
    
    var refreshStatus: PublishRelay<Bool> { get }
    var homeSections: PublishRelay<[HomeSection]> { get }
    var forecastInfo: [HomeForecastInfo] { get }
    var selectedForecastState: BehaviorRelay<HomeForecastInfo> { get }
    var filteredStyle: Bool { get set }
    var filteredItem: Bool { get set }
}

public final class NewHomeViewModel: RxBaseViewModel, NewHomeViewModelLogic {
    private let closetDataSource: ClosetDataSourceProtocol
    
    /// 새로고침 상태
    public var refreshStatus: PublishRelay<Bool>
    /// 홈 전체 정보
    public var homeSections = PublishRelay<[HomeSection]>()
    /// 날씨 정보
    public var forecastInfo: [HomeForecastInfo] = []
    /// 선택돼있는 인덱스
    private var selectedIndex = 0
    /// 선택돼있는 날씨 정보
    public var selectedForecastState = BehaviorRelay<HomeForecastInfo>(value: .init(date: "", time: "", mainTemp: 0, minTemp: 0, maxTemp: 0, weather: "", comment: ""))
    /// 스타일 필터 여부
    public var filteredStyle: Bool
    /// 아이템 필터 여부
    public var filteredItem: Bool
    /// 스타일 추천 리스트
    public var recommendedCloset = BehaviorRelay<[NewClosetInfo]?>(value: nil)
    
    init(
        closetDataSource: ClosetDataSourceProtocol
    ) {
        self.closetDataSource = closetDataSource
        self.refreshStatus = .init()
        self.filteredStyle = .init()
        self.filteredItem = .init()
        super.init()
    }
    
    /// 홈 전체 정보 취합 후 DataSource Reload
    public func loadHome() {
        /// 예보 Section 정보
        let homeForecast: [HomeSection] = [
            .forecast(items: [.forecast(selectedForecastState.value)])
        ]
        
        /// 첫 Cell Banner 처리를 위한 Dummy Data 넣어줌(Banner + List)
        var banner: [NewClosetInfo] = .init()
        guard let data = recommendedCloset.value else { return }
        banner += data
        
        /// 추천 Section 정보
        let closet: [HomeSection] = [
            .closet(items: banner.map { .closet($0) })
        ]
        let combinedData = homeForecast + closet
        homeSections.accept(combinedData)
        refreshStatus.accept(false)
    }
    
    /// 새로고침
    public func pullToRefresh() {
        refreshStatus.accept(true)
        getForecastInfo()
    }
    
    /// 날씨 정보 받아오기
    public func getForecastInfo() {
        // TODO: delete mock
        let data: [HomeForecastInfo] = [
            .init(
                date: "현재",
                time: "오전 9시",
                mainTemp: 18,
                minTemp: 15,
                maxTemp: 25,
                weather: "맑음",
                comment: "해가 쨍쨍"
            ),
            .init(
                date: "오늘",
                time: "오후 3시",
                mainTemp: 25,
                minTemp: 15,
                maxTemp: 25,
                weather: "구름많음",
                comment: "뭉게뭉게 뭉게구름"
            ),
            .init(
                date: "오늘",
                time: "오후 8시",
                mainTemp: 16,
                minTemp: 15,
                maxTemp: 25,
                weather: "흐림",
                comment: "상당히 흐리네요"
            ),
            .init(
                date: "내일",
                time: "오전 9시",
                mainTemp: 18,
                minTemp: 16,
                maxTemp: 20,
                weather: "비",
                comment: "흐리고 비가 내려요. 우산 깜빡하진 않으셨죠?"
            ),
            .init(
                date: "내일",
                time: "오후 3시",
                mainTemp: 20,
                minTemp: 16,
                maxTemp: 20,
                weather: "바람",
                comment: "바람이 겁나게 부네요."
            ),
            .init(
                date: "내일",
                time: "오후 8시",
                mainTemp: 16,
                minTemp: 16,
                maxTemp: 20,
                weather: "맑음",
                comment: "날이 좋네요"
            ),
        ]
        forecastInfo = data
        selectedIndex = 0
        selectedForecastState.accept(forecastInfo[selectedIndex])
        getClosetInfo()
    }
    
    /// 메인 코디 추천 받아오기
    public func getClosetInfo() {
        let dataSource = NewClosetDataSource(provider: WVProvider<NewClosetTarget>())
        dataSource.getMainCloset(page: 1, pageSize: 1)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.recommendedCloset.accept(response.data.list)
                    owner.loadHome()
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup,
                            closeAction: { owner.getClosetInfo() }
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 버튼 액션 케이스
    public func buttonTapAction(action: ButtonTapAction) {
        switch action {
        case .didTapPrev: configureTime(direction: .right)
        case .didTapNext: configureTime(direction: .left)
        case .didTapStyle: filterCloset(state: .style)
        case .didTapItem: filterCloset(state: .item)
        }
    }
    
    /// 시간대 이동 전 시간 판별
    public func configureTime(direction: UISwipeGestureRecognizer.Direction) {
        let info = selectedForecastState.value
        
        if direction == .right {
            if info.date == "현재" {
                alertState.accept(
                    .init(
                        title: "현재보다 이전 시간은 확인할 수 없어요",
                        alertType: .toast
                ))
                return
            }
        } else {
            if (info.date == "내일") && (info.time == "오후 8시") {
                alertState.accept(
                    .init(
                        title: "내일 날씨까지만 볼 수 있어요",
                        alertType: .toast
                    ))
                return
            }
        }
        getSelectedTimeInfo(direction: direction)
    }
    
    /// 시간대 이동
    public func getSelectedTimeInfo(direction: UISwipeGestureRecognizer.Direction) {
        if direction == .right {
            selectedIndex -= 1
        } else {
            selectedIndex += 1
        }
        selectedForecastState.accept(forecastInfo[selectedIndex])
        getClosetInfo()
    }
    
    /// 현재/내일 이동
    public func didTapTimeLabel() {
        let info = selectedForecastState.value
        
        if info.date == "현재" {
            selectedIndex = forecastInfo.count - 3
        } else {
            selectedIndex = 0
        }
        selectedForecastState.accept((forecastInfo[selectedIndex]))
        getClosetInfo()
    }
    
    /// 필터링
    public func filterCloset(state: FilterListViewState) {
        let vc = ClosetFilterViewController(ClosetFilterViewModel(viewState: state))
        presentViewControllerWithAnimationRelay.accept(vc)
    }
    
    /// 상세보기 이동
    public func toDetailView(state: NewClosetInfo) {
        
    }
    
    /// 알림페이지 이동
    public func toNotificationListView() {
        let vc = NotificationListViewController(NotificationListViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    /// 10일간 날씨 예보 이동
    public func toTendaysForecastView() {
        let vc = TenDaysForeCastViewController(TenDaysForecastViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    /// 동네 설정 이동
    public func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel(.edit))
        navigationPushViewControllerRelay.accept(vc)
    }
}
