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
    var testLabel = UILabel()
    var testLabel2 = UILabel()
    
    override func attribute() {
        super.attribute()
        print(#function)
        standard600.do{
            $0.setTitle("버튼 활성화", for: .normal)
        }
        
        standard100.do{
            $0.setTitle("버튼 활성화", for: .normal)
        }
        
        standardWhite.do{
            $0.setTitle("버튼 활성화", for: .normal)
        }
        
        test.do{
            $0.setTitle("버튼 활성화", for: .normal)
        }
        
        testLabel.do {
            $0.text = "Test text"
            $0.font = UIFont.title_3_B
        }
        
        testLabel2.do {
            $0.text = "Test text"
            $0.font = UIFont.title_3_M
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
                flex.addItem(testLabel).width(90%).height(48).marginLeft(20)
                    .marginBottom(40)
                flex.addItem(testLabel2).width(90%).height(48).marginLeft(20)
                    .marginBottom(40)
            }
    }
    
}
