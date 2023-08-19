//
//  OnBoardSensoryTempViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/18.
//

import RxCocoa
import RxSwift

public protocol OnBoardSensoryTempViewModelLogic: ViewModelBusinessLogic {
    func getSensoryTemp()
    func getClosetBySensoryTemp()
    func didTapAcceptButton()
    func toSlotMachineView()
    func toHomeView()
}

public final class OnBoardSensoryTempViewModel: RxBaseViewModel, OnBoardSensoryTempViewModelLogic {
    public let temperatureRelay = BehaviorRelay<String>(value: "")
    public let dateStringRelay: BehaviorRelay<String>
    public let recommendClosetEntityRelay = BehaviorRelay<RecommendClosetEntity?>(value: nil)
    public let closetListByTempRelay = BehaviorRelay<[ClosetList]?>(value: nil)
    private let closetDataSource = ClosetDataSource()
    
    init(_ dateString: String) {
        self.dateStringRelay = BehaviorRelay<String>(value: dateString)
    }
    
    public func getSensoryTemp() {
        // TODO: 체감온도 받아오기
        getClosetBySensoryTemp()
    }
    
    public func getClosetBySensoryTemp() {
        closetDataSource.getOnBoardSensoryTemperatureCloset(temperatureRelay.value)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    let closets = response.data.list
                    self?.closetListByTempRelay.accept(closets)
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self?.alertMessageRelay.accept(.init(title: errorString,
                                                         alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func didTapAcceptButton() {
        closetDataSource.setSensoryTemperature(.init(closet: 1,
                                                     currentTemp: "25"))
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.toHomeView()
                case .failure(let err):
                    guard let errorString = err.errorDescription else { return }
                    self?.alertMessageRelay.accept(.init(title: errorString,
                                                         alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func toSlotMachineView() {
        let vc = HomeViewController(HomeViewModel())
        self.navigationPushViewControllerRelay.accept(vc)
    }
    
    public func toHomeView() {
        let vc = HomeViewController(HomeViewModel())
        self.navigationPushViewControllerRelay.accept(vc)
    }
    
}
