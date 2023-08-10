//
//  HomeSensoryTempViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/07.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol HomeSensoryLogic {
    func getClosetBySensoryTemp()
}
class HomeSensoryTempViewModel: RxBaseViewModel {
    
    let closetDataSource = ClosetDataSource()
    var selectedDate: String = ""
    var closetListByTempRelay = BehaviorRelay<[ClosetList]?>(value: nil)
    
    init(_ selectedDate: String) {
        print(selectedDate)
        self.selectedDate = selectedDate

    }
    
    func getClosetBySensoryTemp() {
        closetDataSource.getSensoryTemperatureCloset(self.selectedDate)
            .subscribe(onNext: { [ weak self ] result in
                switch result {
                case .success(let response):
                    print(response)
                    let closets = response.data.list
                    self?.closetListByTempRelay.accept(closets)
                case .failure(let error):
                    print("viewModel error GetSensoryTemp", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    
}
