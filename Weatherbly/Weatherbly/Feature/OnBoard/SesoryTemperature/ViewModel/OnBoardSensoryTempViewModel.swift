//
//  OnBoardSensoryTempViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/18.
//

import RxCocoa

public protocol OnBoardSensoryTempViewModelLogic: ViewModelBusinessLogic {
    func didTapAcceptButton()
    func toSlotMachineView()
    func toHomeView()
}

public final class OnBoardSensoryTempViewModel: RxBaseViewModel, OnBoardSensoryTempViewModelLogic {
    public let temperatureRelay: BehaviorRelay<String>
    public let recommendClosetEntityRelay = BehaviorRelay<RecommendClosetEntity?>(value: nil)
    private let getRecommendClosetDataSource = ClosetDataSource()
    
    init(_ temperature: String) {
        self.temperatureRelay = BehaviorRelay<String>(value: temperature)
    }
    
    public func getRecommendCloset(_ dateString: String) {
        // TODO: - 시간 파라미터로 받기
//        let date = Date()
//        let dateFormmater = DateFormatter.shared
//        dateFormmater.dateFormat = "yyyy-MM-dd HH:00"
//        print(dateFormmater.string(from: date))
        
        getRecommendClosetDataSource.getRecommendCloset(dateString)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let respone):
                    self?.recommendClosetEntityRelay.accept(respone)
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
        let vc = HomeViewController(HomeViewModel())
        self.navigationPushViewControllerRelay.accept(vc)
    }
    
}
