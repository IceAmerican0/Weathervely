//
//  DateTimePickViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/14.
//

import Foundation
import RxCocoa

public protocol DateTimePickViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton(_ today: [String], _ pickerDay: String, _ pickerDayTime: String, _ pickerTime: Int)
    func getTempBaseOnTime()
    func toOnBoardSensoryTempView(_ dateString: String)
}

public class DateTimePickViewModel: RxBaseViewModel, DateTimePickViewModelLogic {
    public func didTapConfirmButton(_ today: [String], _ pickerDay: String, _ pickerDayTime: String, _ pickerTime: Int) {
//        debugPrint("선택시간: ", today, pickerDay , pickerDayTime , pickerTime)
        /// 시간비교
        if today[2] == "오전" {
            if pickerDay == "오늘" {
                if pickerDayTime == "오전" {
                    // 시간 비교
                    if Int(today[3])! > pickerTime {
                        self.alertMessageRelay.accept(.init(title: "미래 시간은 선택 할 수 없어요",
                                                            alertType: .Info))
                    } else {
                        getTempBaseOnTime()
                    }
                } else { // 선택시간이 오후
                    self.alertMessageRelay.accept(.init(title: "미래 시간은 선택 할 수 없어요",
                                                        alertType: .Info))
                }
            } else {
                getTempBaseOnTime()
            }
        } else { // 지금이 오후
            if pickerDay == "오늘" {
                if pickerDayTime == "오후" {
                    //시간비교
                    if Int(today[3])! < pickerTime {
                        self.alertMessageRelay.accept(.init(title: "미래 시간은 선택 할 수 없어요",
                                                            alertType: .Info))
                    } else {
                        getTempBaseOnTime()
                    }
                } else {
                    getTempBaseOnTime()
                }
            } else {
                getTempBaseOnTime()
            }
        }
    }
    
    public func getTempBaseOnTime() {
        // TODO: 시간으로 온도 받아오기
        toOnBoardSensoryTempView("15")
    }
    
    public func toOnBoardSensoryTempView(_ temperature: String) {
        
        let vc = OnBoardSensoryTempViewController(OnBoardSensoryTempViewModel(temperature))
        navigationPushViewControllerRelay.accept(vc)
    }
}
