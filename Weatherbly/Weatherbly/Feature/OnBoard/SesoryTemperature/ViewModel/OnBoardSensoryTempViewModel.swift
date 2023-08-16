//
//  OnBoardSensoryTempViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/18.
//

import RxCocoa

public protocol OnBoardSensoryTempViewModelLogic: ViewModelBusinessLogic {
    func getClosetBySensoryTemp()
    func didTapAcceptButton()
    func toSlotMachineView()
    func toHomeView()
}

public final class OnBoardSensoryTempViewModel: RxBaseViewModel, OnBoardSensoryTempViewModelLogic {
    public let temperatureRelay: BehaviorRelay<String>
    public var dateString = ""
    public let recommendClosetEntityRelay = BehaviorRelay<RecommendClosetEntity?>(value: nil)
    public let closetListByTempRelay = BehaviorRelay<[ClosetList]?>(value: nil)
    private let closetDataSource = ClosetDataSource()
    
    init(_ temperature: String) {
        self.temperatureRelay = BehaviorRelay<String>(value: temperature)
    }
    
    public func getClosetBySensoryTemp() {
        closetDataSource.getSensoryTemperatureCloset(dateString)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let response):
                    let closets = response.data.list
                    self?.closetListByTempRelay.accept(closets)
                case .failure(let error):
                    guard let errorString = error.errorDescription else { return }
                    self?.alertMessageRelay.accept(.init(title: errorString,
                                                         alertType: .Error))
                }
            })
            .disposed(by: bag)
    }
    
    public func didTapAcceptButton() {
        toHomeView()
    }
    
    public func toSlotMachineView() {
        let vc = HomeViewController(HomeViewModel())
        self.navigationPushViewControllerRelay.accept(vc)
    }
    
    public func toHomeView() {
        userDefault.removeObject(forKey: UserDefaultKey.isOnboard.rawValue)
        let vc = HomeViewController(HomeViewModel())
        self.navigationPushViewControllerRelay.accept(vc)
    }
    
}
