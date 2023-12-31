//
//  CSButtonTests.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/29/23.
//

import Foundation
import UIKit
import Then
import FlexLayout
import RxSwift

class CSButtonTestsViewController: RxBaseViewController<EmptyViewModel> {
    
    var standard600 = NewCSButton(.standard, style: .violet600)
    var standard100 = NewCSButton(.standard, style: .violet100)
    var standardWhite = NewCSButton(.standard, style: .white)
    var test = CSButton(.primary)
    
    override func attribute() {
        super.attribute()
        
        standard600.do{
            $0.setTitle("버튼활성화", for: .normal)
        }
        
        standard100.do{
            $0.setTitle("버튼활성화", for: .normal)
        }
        
        standardWhite.do{
            $0.setTitle("버튼활성화", for: .normal)
        }
        
        test.do{
            $0.setTitle("버튼활성화", for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex
            .justifyContent(.center)
            .define { flex in
                flex.addItem(standard600).width(90%).height(48).marginLeft(20)
                    .marginBottom(40)
                flex.addItem(standard100).width(90%).height(48).marginLeft(20)
                    .marginBottom(40)
                flex.addItem(standardWhite).width(90%).height(48).marginLeft(20)
                    .marginBottom(40)
                flex.addItem(test).width(90%).height(48).marginLeft(20)
                    .marginBottom(40)
            }
    }
    
}
