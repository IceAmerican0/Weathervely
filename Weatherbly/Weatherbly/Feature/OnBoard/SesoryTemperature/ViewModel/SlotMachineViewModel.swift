//
//  SlotMachineViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/18.
//

import RxCocoa

public protocol SlotMachineViewModelLogic: ViewModelBusinessLogic {
    func didTapAcceptButton()
    func toHomeView()
}

public class SlotMachineViewModel: RxBaseViewModel, SlotMachineViewModelLogic {
    public let labelStringRelay: BehaviorRelay<String>
    public let temperatureRelay: BehaviorRelay<String>
    public let closetListRelay: BehaviorRelay<[ClosetList]?>
    public let closetIDRelay: BehaviorRelay<Int>
    
    init(_ labelStringRelay: BehaviorRelay<String>,
         _ temperatureRelay: BehaviorRelay<String>,
         _ closetListRelay: BehaviorRelay<[ClosetList]?>,
         _ closetIDRelay: BehaviorRelay<Int>) {
        self.labelStringRelay = labelStringRelay
        self.temperatureRelay = temperatureRelay
        self.closetListRelay = closetListRelay
        self.closetIDRelay = closetIDRelay
    }
    
    public func didTapAcceptButton() {
        let closetDataSource = ClosetDataSource()
        closetDataSource.setSensoryTemperature(.init(closet: closetIDRelay.value,
                                                     currentTemp: temperatureRelay.value))
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.toHomeView()
                case .failure(let err):
                    switch err {
                    case .noInternetError:
                        self?.navigationPushViewControllerRelay.accept(LoadErrorViewController(LoadErrorViewModel()))
                    default:
                        guard let errorString = err.errorDescription else { return }
                        self?.alertMessageRelay.accept(.init(title: errorString,
                                                             alertType: .Error))
                    }
                }
            })
            .disposed(by: bag)
    }
    
    public func toHomeView() {
        let vc = HomeViewController(HomeViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
