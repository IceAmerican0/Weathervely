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
    var closetIdRelay = BehaviorRelay<Int?>(value: nil)
    var closetListByTempRelay = BehaviorRelay<[ClosetList]?>(value: nil)
    
    init(_ selectedDate: String, _ closetId: Int) {
        print(selectedDate)
        self.selectedDate = selectedDate
        self.closetIdRelay.accept(closetId)

    }
    
    func getClosetBySensoryTemp() {
        closetDataSource.getMainSensoryTemperatureCloset(selectedDate, closetIdRelay.value!)
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
    
    func getCurrentIndex(_ closets: [ClosetList]) {
        
        closets.forEach { element in
            element.id
        }
    }
}
