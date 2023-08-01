//
//  ConnectionLostViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit
import FlexLayout
import PinLayout

final class ConnectionLostViewController: RxBaseViewController<EmptyViewModel> {
    private var topLayoutWrapper = UIView()
    private var settingButton = UIButton()
    private var mainLabel = CSLabel(.bold, 20, "00동 | 현재")
    private var calendarButton = UIButton()
    private var todayButton = CSButton(.primary)
    
    override func attribute() {
        super.attribute()
        
        settingButton.do {
            $0.setImage(AssetsImage.setting.image, for: .normal)
        }
        
        calendarButton.do {
            $0.setImage(AssetsImage.schedule.image, for: .normal)
        }
        
        todayButton.do {
            $0.setTitle("오늘 옷차림", for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(topLayoutWrapper).direction(.row).marginTop(7).define { flex in
                flex.addItem(settingButton).size(44)
                flex.addItem(mainLabel).width(67%)
                flex.addItem(calendarButton).size(44)
            }
            
            flex.addItem(todayButton).marginRight(20).width(100).height(40)
        }
    }
}
