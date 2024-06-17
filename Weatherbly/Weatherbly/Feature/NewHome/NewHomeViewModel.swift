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
    func getStyleFilterList()
    func getClosetInfo()
    func buttonTapAction(action: ButtonTapAction)
    func configureTime(direction: UISwipeGestureRecognizer.Direction)
    func getSelectedTimeInfo(direction: UISwipeGestureRecognizer.Direction)
    func didTapTimeLabel()
    func filterCloset(delegate: StyleListViewDelegate)
    func stylePicked(closetID: Int)
    func toDetailView(state: NewClosetInfo)
    func toEditRegionView()
    func toNotificationListView()
    func toTendaysForecastView()
    
    var shimmerStatus: PublishRelay<Bool> { get }
    var refreshStatus: PublishRelay<Bool> { get }
    var homeSections: BehaviorRelay<[HomeSection]> { get }
    var forecastInfo: [HomeForecastInfo] { get }
    var selectedIndex: BehaviorRelay<Int> { get }
    var selectedForecastState: BehaviorRelay<HomeForecastInfo> { get }
    var styleFilterList: [StyleTypeInfo] { get }
    var isLoading: Bool { get }
}

public final class NewHomeViewModel: RxBaseViewModel, NewHomeViewModelLogic {
    private let closetDataSource: NewClosetDataSourceProtocol = NewClosetDataSource()
    
    /// 첫 실행 shimmer 여부
    public var shimmerStatus: PublishRelay<Bool> = .init()
    /// 새로고침 상태
    public var refreshStatus: PublishRelay<Bool> = .init()
    /// 홈 전체 정보
    public var homeSections = BehaviorRelay<[HomeSection]>(value: [])
    /// 날씨 정보
    public var forecastInfo: [HomeForecastInfo] = []
    /// 선택돼있는 인덱스
    public var selectedIndex = BehaviorRelay<Int>(value: 0)
    /// 선택돼있는 날씨 정보
    public var selectedForecastState = BehaviorRelay<HomeForecastInfo>(value: .init(date: "", time: "", currentTemp: "", minTemp: "", maxTemp: "", weather: "", comment: ""))
    /// 스타일 필터 리스트
    public var styleFilterList: [StyleTypeInfo] = []
    /// 스타일 추천 리스트
    private var closetList: [NewClosetInfo] = []
    /// pagination 로딩 여부
    public var isLoading = false
    /// pagination용 리스트 총 개수
    private var closetListMaxCount = 0
    /// pagination용 이미 로드된 페이지
    private var loadedPage = 0
    
    /// 홈 전체 정보 취합 후 DataSource Reload
    public func loadHome() {
        /// 예보 Section 정보
        let homeForecast: [HomeSection] = [
            .forecast(items: [.forecast(selectedForecastState.value)])
        ]
        
        /// 첫 Cell Banner 처리를 위한 Dummy Data 넣어줌(Banner + List)
        var banner: [NewClosetInfo] = [.init(closetId: -1, closetName: "", closetImageUrl: "", closetStatus: "")]
        banner += closetList
        
        /// 추천 Section 정보
        let closet: [HomeSection] = [
            .closet(items: banner.map { .closet($0) })
        ]
        let combinedData = homeForecast + closet
        shimmerStatus.accept(true)
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
        let dataSource: ForecastDataSourceProtocol = ForecastDataSource()
        dataSource.getVillageForcast()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let data = response.data
                    owner.forecastInfo = data.forecast
                    owner.selectedIndex.accept(0)
                    owner.selectedForecastState.accept(owner.forecastInfo[owner.selectedIndex.value])
                    owner.styleFilterList.count == 0 ? owner.getStyleFilterList() : owner.getClosetInfo()
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                    owner.refreshStatus.accept(false)
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 스타일 필터 리스트 받아오기
    public func getStyleFilterList() {
        let dataSource = TypeDataSource(provider: WVProvider<TypeTarget>())
        dataSource.getTypeList()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.styleFilterList = response.data.types
                    owner.getClosetInfo()
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                    owner.refreshStatus.accept(false)
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup,
                            closeAction: { owner.getStyleFilterList() }
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 메인 코디 추천 받아오기 (첫페이지)
    public func getClosetInfo() {
        closetDataSource.getHomeCloset(page: 1)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.closetList = response.data.closets
                    owner.closetListMaxCount = response.data.counts
                    owner.loadedPage = 1
                    owner.loadHome()
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                    owner.refreshStatus.accept(false)
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 메인 코디 추천 받아오기 (스크롤 후 로드)
    public func getNextCloset(of row: Int) {
        
        /**
         마지막 페이지 or 일정 이상 스크롤되지 않았을시 return
         페이지당 row 10 / 80퍼 이상 스크롤
         */
        if loadedPage >= (closetListMaxCount / 20) || 
           (row >= Int(Double(loadedPage * 10) * 0.8)) == false { return }
        
        guard !isLoading else { return }
        isLoading = true
        
        loadedPage += 1
        
        closetDataSource.getHomeCloset(page: loadedPage)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let closet = response.data.closets.map { HomeSectionItem.closet($0) }
                    var closetSectionList = owner.homeSections.value
                    
                    // 기존 리스트에 불러온 리스트 추가
                    for (index, section) in closetSectionList.enumerated() {
                        if case .closet(let items) = section {
                            var newItem = items
                            newItem.append(contentsOf: closet)
                            closetSectionList[index] = .closet(items: newItem)
                        }
                    }
                    owner.homeSections.accept(closetSectionList)
                    
                    owner.closetListMaxCount = response.data.counts
                    owner.isLoading = false
                },
                onError: { owner, error in
                    owner.refreshStatus.accept(false)
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .popup
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
        }
    }
    
    /// 시간대 이동 전 시간 판별
    public func configureTime(direction: UISwipeGestureRecognizer.Direction) {
        let info = selectedForecastState.value
        
        if direction == .right {
            if selectedIndex.value == 0 {
                alertState.accept(
                    .init(
                        title: "현재보다 이전 시간은 확인할 수 없어요",
                        alertType: .toast
                ))
                return
            }
        } else {
            if selectedIndex.value + 1 == forecastInfo.count {
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
        let index = selectedIndex.value
        if direction == .right {
            selectedIndex.accept(index - 1)
        } else {
            selectedIndex.accept(index + 1)
        }
        selectedForecastState.accept(forecastInfo[selectedIndex.value])
        getClosetInfo()
    }
    
    /// 현재/내일 이동
    public func didTapTimeLabel() {
        let info = selectedForecastState.value
        
        if info.date == "현재" {
            selectedIndex.accept(forecastInfo.count - 3)
        } else {
            selectedIndex.accept(0)
        }
        selectedForecastState.accept((forecastInfo[selectedIndex.value]))
        getClosetInfo()
    }
    
    /// 필터링
    public func filterCloset(delegate: StyleListViewDelegate) {
        let vc = FilterListViewController(FilterListViewModel())
        vc.delegate = delegate
        vc.setBottomSheet()
        presentViewControllerWithAnimationRelay.accept(vc)
    }
    
    /// 스타일 선택 히스토리 저장
    public func stylePicked(closetID: Int) {
        let dataSource: ClosetDataSourceProtocol = ClosetDataSource()
        dataSource.stylePicked(closetID)
            .subscribe(
                with: self,
                onError: { _, error in
                    debugPrint(error.localizedDescription)
                }
            ).disposed(by: bag)
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
