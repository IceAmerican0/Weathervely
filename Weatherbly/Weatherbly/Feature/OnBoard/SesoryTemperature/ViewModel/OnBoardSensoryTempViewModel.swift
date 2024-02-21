//
//  OnBoardSensoryTempViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/18.
//

import Foundation
import RxCocoa
import RxSwift

public protocol OnBoardSensoryTempViewModelLogic: ViewModelBusinessLogic {
    func getInfo()
    func getDateString()
    func getClosetBySensoryTemp()
    func didTapAcceptButton()
    func toSlotMachineView()
    func toHomeView()
}

public final class OnBoardSensoryTempViewModel: RxBaseViewModel, OnBoardSensoryTempViewModelLogic {
    public var temperatureRelay = BehaviorRelay<String>(value: "")
    public var dateStringRelay = BehaviorRelay<String>(value: "")
    public var formattedDateStringRelay = BehaviorRelay<String>(value: "")
    public let closetListRelay = BehaviorRelay<[ClosetList]?>(value: nil)
    public let closetIDRelay = BehaviorRelay<Int>(value: 0)
    
    private let closetDataSource = ClosetDataSource()
    
    private let pickerDay: String
    private let pickerDayTime: String
    private let pickerTime: Int
    
    init(_ pickerDay: String, _ pickerDayTime: String, _ pickerTime: Int) {
        self.pickerDay = pickerDay
        self.pickerDayTime = pickerDayTime
        self.pickerTime = pickerTime
    }
    
    public func getInfo() {
        getDateString()
        getClosetBySensoryTemp()
    }
    
    public func getDateString() {
        dateStringRelay = BehaviorRelay<String>(value: "\(pickerDay) \(pickerDayTime) \(pickerTime)")
        
        var formattedString = ""
        if pickerDay == "어제" {
            formattedString.append("\(Date().yesterdayHyphenFormat) ")
        } else {
            formattedString.append("\(Date().todayphenFormat) ")
        }
        
        formattedString.append(configureThousand())
        formattedDateStringRelay = BehaviorRelay<String>(value: formattedString)
    }
    
    func configureThousand() -> String {
        if pickerDayTime == "오후" {
            return ("\((pickerTime + 12) * 100)".addColon)
        } else {
            if pickerTime > 9 {
                return ("\(pickerTime * 100)".addColon)
            } else {
                return ("0\(pickerTime * 100)".addColon)
            }
        }
    }
    
    public func getClosetBySensoryTemp() {
        closetDataSource.getOnBoardSensoryTemperatureCloset(formattedDateStringRelay.value)
            .subscribe(
                with: self,
                onNext: { owner, response in
                    let data = response.data
                    owner.temperatureRelay.accept(data.fcstValue)
                    owner.closetListRelay.accept(data.list)
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup,
                                                         closeAction: owner.popViewController))
            })
            .disposed(by: bag)
    }
    
    public func didTapAcceptButton() {
        closetDataSource.setSensoryTemperature(.init(closet: closetIDRelay.value,
                                                     currentTemp: temperatureRelay.value))
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.toHomeView()
                },
                onError: { owner, error in
                    owner.alertState.accept(.init(title: error.localizedDescription,
                                                         alertType: .popup))
            })
            .disposed(by: bag)
    }
    
    public func toSlotMachineView() {
        let vc = SlotMachineViewController(SlotMachineViewModel(dateStringRelay,
                                                                temperatureRelay,
                                                                closetListRelay,
                                                                closetIDRelay))
        self.navigationPushViewControllerRelay.accept(vc)
    }
    
    public func toHomeView() {
        let vc = HomeTabBarController()
        self.navigationPushViewControllerRelay.accept(vc)
    }
    
    func popViewController() {
        navigationPopViewControllerRelay.accept(Void())
    }
}
