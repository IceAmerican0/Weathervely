//
//  HomeSensoryTempViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/07.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol HomeSensoryTempViewControllerDelegate: AnyObject {
    func willDismiss()
}

protocol HomeSensoryLogic: ViewModelBusinessLogic {
    func getClosetBySensoryTemp()
    func setSensoryTemperature()
    func getCurrentIndex(_ closets: [ClosetList])
    func yOffsetForIndex(_ index: Int, _ scrollView: UIScrollView?)
}

class HomeSensoryTempViewModel: RxBaseViewModel, HomeSensoryLogic {
    weak var delegate: HomeSensoryTempViewControllerDelegate?
    let closetDataSource = ClosetDataSource()
    
    var closetIdFromHomeViewRelay = BehaviorRelay<Int?>(value: nil)
    var closetListByTempRelay = BehaviorRelay<[ClosetList]?>(value: nil)
    
    var selectedDateRelay = BehaviorRelay<String?>(value: nil)
    var selectedTimeRelay = BehaviorRelay<String?>(value: nil)
    var selectedTempRelay = BehaviorRelay<String?>(value: nil)
    
    var setClosetIdRelay = BehaviorRelay<Int?>(value: nil)
    var setClosetTempRelay = BehaviorRelay<String?>(value: nil)
    
    var slotMachineIndexRelay = BehaviorRelay<Int>(value: 0)
    var focusingIndexRelay = BehaviorRelay<CGFloat>(value: CGFloat())
    
    init(_ selectedDate: String, _ selectedTime: String, _ selectedTemp: String,  _ closetId: Int) {
        self.selectedDateRelay.accept(selectedDate)
        self.selectedTimeRelay.accept(selectedTime)
        self.selectedTempRelay.accept(selectedTemp)
        self.closetIdFromHomeViewRelay.accept(closetId)
    }
    
    func getClosetBySensoryTemp() {
        guard let selectedDate = self.selectedDateRelay.value,
              let closetId = self.closetIdFromHomeViewRelay.value
        else { return }
        
        closetDataSource.getMainSensoryTemperatureCloset(selectedDate, closetId)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let closets = response.data.list
                    owner.getCurrentIndex(closets)
                    //                    owner.closetListByTempRelay.accept(closets)
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup,
                                                         closeAction: owner.popViewController))
            })
            .disposed(by: bag)
    }
    
    func setSensoryTemperature() {
        guard let closetId = setClosetIdRelay.value,
              let currentTemp = selectedTempRelay.value?.dropLast()
        else { return }
        
        closetDataSource.setSensoryTemperature(.init(closet: closetId, currentTemp: String(currentTemp)))
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.delegate?.willDismiss()
                    owner.dismissSelfWithAnimationRelay.accept(Void())
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup))
            })
            .disposed(by: bag)
    }
    
    func getCurrentIndex(_ closets: [ClosetList]) {
        for i in 0..<closets.count {
            if (closets[i].closetId == self.closetIdFromHomeViewRelay.value!) {
                // index 없데이트
                
                self.slotMachineIndexRelay.accept(i)
                self.setClosetIdRelay.accept(closets[i].closetId)
                break
            }
        }
        
        self.closetListByTempRelay.accept(closets)
    }
    
    func yOffsetForIndex(_ index: Int, _ scrollView: UIScrollView?) {
        let slotMachineIndex = slotMachineIndexRelay.value
        focusingIndexRelay.accept(CGFloat(slotMachineIndex) * (scrollView?.bounds.height)!)
    }
    
    private func popViewController() {
        self.navigationPopViewControllerRelay.accept(Void())
    }
}
