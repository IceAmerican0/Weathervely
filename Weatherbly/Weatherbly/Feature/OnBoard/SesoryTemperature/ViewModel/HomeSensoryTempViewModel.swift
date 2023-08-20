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
import UIKit


protocol HomeSensoryTempViewControllerDelegate: AnyObject {
    func willDismiss()
}

protocol HomeSensoryLogic {
    func getClosetBySensoryTemp()
    func setSensoryTemperature()
    func getCurrentIndex(_ closets: [ClosetList])
    func yOffsetForIndex(_ index: Int)
}
class HomeSensoryTempViewModel: RxBaseViewModel {
    
    weak var delegate: HomeSensoryTempViewControllerDelegate?
    let closetDataSource = ClosetDataSource()
    
    var closetIdFromHomeViewRelay = BehaviorRelay<Int?>(value: nil)
    var closetListByTempRelay = BehaviorRelay<[ClosetList]?>(value: nil)

    
    var selectedDateRelay = BehaviorRelay<String?>(value: nil)
    var selectedTimeRelay = BehaviorRelay<String?>(value: nil)
    var selectedTempRelay = BehaviorRelay<String?>(value: nil)
    
    var setClosetIdRelay = BehaviorRelay<Int?>(value: nil)
    var setClosetTempRelay = BehaviorRelay<String?>(value: nil)
    var emptyEntityRelay = BehaviorRelay<EmptyEntity?>(value: nil)
    
    var slotMachineIndexRelay = BehaviorRelay<Int>(value: 0)
    var focusingIndexRelay = BehaviorRelay<CGFloat>(value: CGFloat())
    
    override init() {
        super.init()
    }
    
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
            .subscribe(onNext: { [ weak self ] result in
                switch result {
                case .success(let response):
                    let closets = response.data.list
                    self?.getCurrentIndex(closets)
                    
//                    self?.closetListByTempRelay.accept(closets)
                case .failure(let error):
                    debugPrint("viewModel error GetSensoryTemp", error.localizedDescription)
                }
            })
            .disposed(by: bag)
    }
    
    func setSensoryTemperature() {
        
        guard let closetId = setClosetIdRelay.value,
              var currentTemp = selectedTempRelay.value?.dropLast()
        else { return }
        
        closetDataSource.setSensoryTemperature(.init(closet: closetId, currentTemp: String(currentTemp)))
            .subscribe(onNext: { [weak self] result in
                switch result {
                case.success(let response):
                    self?.delegate?.willDismiss()
                    self?.dismissSelfWithAnimationRelay.accept(Void())
                    break
                case .failure(let error):
                
                    debugPrint("viewModel error setTemperature", error.localizedDescription)

                }
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
        var slotMachineIndex = slotMachineIndexRelay.value
        focusingIndexRelay.accept(CGFloat(slotMachineIndex) * (scrollView?.bounds.height)!)
    }
    
    
}
