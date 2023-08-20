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
    func toOnBoardSensoryTempView(_ pickerDay: String, _ pickerDayTime: String, _ pickerTime: Int)
}

public class DateTimePickViewModel: RxBaseViewModel, DateTimePickViewModelLogic {
    public func didTapConfirmButton(_ today: [String], _ pickerDay: String, _ pickerDayTime: String, _ pickerTime: Int) {
        var pickerTime = pickerTime
        if pickerDay == "어제" && pickerDayTime == "오전" {
            pickerTime += 3
        }
        print("선택시간: ", today, pickerDay , pickerDayTime , pickerTime)
        /// 시간비교
        if today[2] == "오전" {
            if pickerDay == "오늘" {
                if pickerDayTime == "오전" {
                    // 시간 비교
                    if Int(today[3])! < (pickerTime == 12 ? 0 : pickerTime) {
                        self.alertMessageRelay.accept(.init(title: "미래 시간은 선택 할 수 없어요",
                                                            alertType: .Info))
                    } else {
                        toOnBoardSensoryTempView(pickerDay, pickerDayTime, pickerTime)
                    }
                } else { // 선택시간이 오후
                    self.alertMessageRelay.accept(.init(title: "미래 시간은 선택 할 수 없어요",
                                                        alertType: .Info))
                }
            } else {
                toOnBoardSensoryTempView(pickerDay, pickerDayTime, pickerTime)
            }
        } else { // 지금이 오후
            if pickerDay == "오늘" {
                if pickerDayTime == "오후" {
                    //시간비교
                    if Int(today[3])! < pickerTime {
                        self.alertMessageRelay.accept(.init(title: "미래 시간은 선택 할 수 없어요",
                                                            alertType: .Info))
                    } else {
                        toOnBoardSensoryTempView(pickerDay, pickerDayTime, pickerTime)
                    }
                } else {
                    toOnBoardSensoryTempView(pickerDay, pickerDayTime, pickerTime)
                }
            } else {
                toOnBoardSensoryTempView(pickerDay, pickerDayTime, pickerTime)
            }
        }
    }
    
    public func toOnBoardSensoryTempView(_ pickerDay: String, _ pickerDayTime: String, _ pickerTime: Int) {
        let vc = OnBoardSensoryTempViewController(OnBoardSensoryTempViewModel(pickerDay, pickerDayTime, pickerTime))
        navigationPushViewControllerRelay.accept(vc)
    }
}
