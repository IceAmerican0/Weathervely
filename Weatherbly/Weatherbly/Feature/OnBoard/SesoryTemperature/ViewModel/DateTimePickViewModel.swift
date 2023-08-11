//
//  DateTimePickViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/14.
//

import Foundation

public protocol DateTimePickViewModelLogic: ViewModelBusinessLogic {
    func didTapConfirmButton(_ today: [String], _ pickerDay: String, _ pickerDayTime: String, _ pickerTime: Int)
    func getTempBaseOnTime()
    func toOnBoardSensoryTempView()
}

public class DateTimePickViewModel: RxBaseViewModel, DateTimePickViewModelLogic {
    public func didTapConfirmButton(_ today: [String], _ pickerDay: String, _ pickerDayTime: String, _ pickerTime: Int) {
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
//                print("선택시간: ", pickerDay , pickerDayTime , pickerTime)
    }
    
    public func getTempBaseOnTime() {
        // TODO: 시간으로 온도 받아오기
        toOnBoardSensoryTempView()
    }
    
    public func toOnBoardSensoryTempView() {
        let vc = OnBoardSensoryTempViewController(OnBoardSensoryTempViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
