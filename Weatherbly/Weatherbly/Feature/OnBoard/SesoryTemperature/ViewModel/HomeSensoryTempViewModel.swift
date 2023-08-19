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
    var selectedDateRelay = BehaviorRelay<String?>(value: nil)
    var closetIdRelay = BehaviorRelay<Int?>(value: nil)
    var closetListByTempRelay = BehaviorRelay<[ClosetList]?>(value: nil)
    var slotMachineIndexRelay = BehaviorRelay<Int>(value: 0)
    var testRelay = BehaviorRelay<CGFloat>(value: CGFloat())
    
    init(_ selectedDate: String, _ closetId: Int) {
        print(selectedDate)
        self.selectedDateRelay.accept(selectedDate)
        self.closetIdRelay.accept(closetId)

    }
    
    func getClosetBySensoryTemp() {
        
        guard let selectedDate = self.selectedDateRelay.value,
              let closetId = self.closetIdRelay.value
        else { return }
        
        closetDataSource.getMainSensoryTemperatureCloset(selectedDate, closetId)
            .subscribe(onNext: { [ weak self ] result in
                switch result {
                case .success(let response):
                    print(response)
                    let closets = response.data.list
                    self?.getCurrentIndex(closets)
//                    self?.closetListByTempRelay.accept(closets)
                case .failure(let error):
                    print("viewModel error GetSensoryTemp", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    func getCurrentIndex(_ closets: [ClosetList]) {
       
        for i in 0..<closets.count {
            if (closets[i].closetId == self.closetIdRelay.value!) {
                // index 없데이트
                
                self.slotMachineIndexRelay.accept(i)
                break
            }
        }
        self.closetListByTempRelay.accept(closets)
    }
    
    
}
