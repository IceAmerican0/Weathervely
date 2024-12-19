//
//  HomeViewModel.swift
//  Weatherbly
//
//  Created by Khai on 12/31/23.
//

import WVAlert
import UIUtil
import WVNetwork
import UIKit
import RxRelay

public protocol HomeViewModelLogic: ViewModelBusinessLogic {
    func loadHome()
    func pullToRefresh()
    func getForecastInfo()
    func getStyleFilterList()
    func getClosetInfo()
    func getNextCloset(of row: Int)
    func buttonTapAction(action: ButtonTapAction)
    func getSelectedTimeInfo(direction: UISwipeGestureRecognizer.Direction)
    func didTapTimeLabel()
    func stylePicked(closetID: Int)
    
    var shimmerStatus: PublishRelay<Bool> { get }
    var refreshStatus: PublishRelay<Bool> { get }
    var homeSections: BehaviorRelay<[HomeSection]> { get }
    var forecastInfo: [HomeForecastInfo] { get }
    var selectedIndex: BehaviorRelay<Int> { get }
    var styleFilterList: [CategoryInfo] { get }
    var selectedTime: String { get }
}

public final class HomeViewModel: RxBaseViewModel, HomeViewModelLogic {
    private let forecastDataSource: ForecastDataSourceProtocol = ForecastDataSource()
    private let closetDataSource: ClosetDataSourceProtocol = ClosetDataSource()
    
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
    /// 스타일 필터 리스트
    public var styleFilterList: [CategoryInfo] = []
    /// 현재 보고 있는 시간
    public var selectedTime = ""
    /// 스타일 추천 리스트
    private var closetList: [ClosetInfo] = []
    /// pagination용 리스트 총 개수
    private var closetListMaxCount = 0
    /// pagination용 이미 로드된 페이지
    private var loadedPage = 0
    
    /// 홈 전체 정보 취합 후 DataSource Reload
    public func loadHome() {
        if forecastInfo.isEmpty || styleFilterList.isEmpty || closetList.isEmpty {
            settingEmptySection()
        }
        
        /// 예보 Section 정보
        let homeForecast: [HomeSection] = [
            .forecast(items: [.forecast(forecastInfo)])
        ]
        
        /// 첫 Cell Banner 처리를 위한 Dummy Data 넣어줌(Banner + List)
        var banner: [ClosetInfo] = [
            .init(
                closetId: -1, 
                closetName: "",
                closetImageUrl: "",
                closetStatus: "",
                closetSiteName: "",
                temperature: ClosetTemp.init(
                    tempId: 0,
                    maxTemp: 0,
                    minTemp: 0
                )
            )
        ]
        
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
        forecastDataSource.getVillageForcast()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let data = response.data
                    owner.forecastInfo = data.forecast
                    owner.selectedIndex.accept(0)
                    owner.styleFilterList.isEmpty ? owner.getStyleFilterList() : owner.getClosetInfo()
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                    owner.refreshStatus.accept(false)
                    owner.loadHome()
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 스타일 필터 리스트 받아오기
    public func getStyleFilterList() {
        closetDataSource.getTypes()
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.styleFilterList = response.data.types
                    owner.getClosetInfo()
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                    owner.refreshStatus.accept(false)
                    owner.loadHome()
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 메인 코디 추천 받아오기 (첫페이지)
    public func getClosetInfo() {
        let info = forecastInfo[selectedIndex.value]
        selectedTime = String().toTimeString(day: info.date, time: info.time ?? "오전 12시")
        closetDataSource.getHomeCloset(page: 1, time: selectedTime)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    owner.closetList = response.data.closets.shuffled()
                    owner.closetListMaxCount = response.data.counts
                    owner.loadedPage = 1
                    owner.loadHome()
                },
                onError: { owner, error in
                    owner.shimmerStatus.accept(true)
                    owner.refreshStatus.accept(false)
                    owner.loadHome()
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
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
//        if Double(loadedPage) >= Double(closetListMaxCount) / 20.0 { return }
        loadedPage += 1
        
        closetDataSource.getHomeCloset(page: loadedPage, time: selectedTime)
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
                },
                onError: { owner, error in
                    owner.refreshStatus.accept(false)
                    AlertManager.shared.present(
                        state: .init(title: error.localizedDescription)
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 버튼 액션 케이스
    public func buttonTapAction(action: ButtonTapAction) {
        switch action {
        case .didTapPrev: getSelectedTimeInfo(direction: .right)
        case .didTapNext: getSelectedTimeInfo(direction: .left)
        }
    }
    
    /// 시간대 이동
    public func getSelectedTimeInfo(direction: UISwipeGestureRecognizer.Direction) {
        let index = selectedIndex.value
        if direction == .right {
            selectedIndex.accept(index - 1)
        } else {
            selectedIndex.accept(index + 1)
        }
    }
    
    /// 현재/내일 이동
    public func didTapTimeLabel() {
        if selectedIndex.value == 0 {
            selectedIndex.accept(forecastInfo.count - 3)
        } else {
            selectedIndex.accept(0)
        }
    }
    
    /// 스타일 선택 히스토리 저장
    public func stylePicked(closetID: Int) {
        closetDataSource.stylePicked(closetID)
            .subscribe(
                with: self,
                onError: { _, error in
                    debuggerPrint(error.localizedDescription)
                }
            ).disposed(by: bag)
    }
    
    /// 홈 로드 실패시 빈 값 세팅
    private func settingEmptySection() {
        forecastInfo = []
        styleFilterList = []
        closetList = []
        
        forecastInfo.append(
            .init(
                date: "",
                time: "",
                currentTemp: "",
                minTemp: "",
                maxTemp: "",
                weather: "",
                comment: ""
            )
        )
        
        styleFilterList = [
            .init(id: -1, name: ""),
            .init(id: -1, name: "")
        ]
        
        for _ in 0..<5 {
            closetList.append(
                .init(
                    closetId: -2, 
                    closetName: "",
                    closetImageUrl: "",
                    closetStatus: "", 
                    closetSiteName: "",
                    temperature: .init(
                        tempId: 0,
                        maxTemp: 0,
                        minTemp: 0
                    )
                )
            )
        }
    }
}
