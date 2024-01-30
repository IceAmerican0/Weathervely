//
//  HeritageTest.swift
//  Weatherbly
//
//  Created by 최수훈 on 1/28/24.
//

/// RxBaseScrollViewController 테스트를 위한 클래스 작성

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift

class HeritageRBViewController: RxBaseScrollViewController<StyleViewModel> {
    
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make("스타일")
    private var btn1 = NewCSButton(.standard, style: .violet600)
    private var btn2 = NewCSButton(.standard, style: .violet600)
    private var btn3 = NewCSButton(.standard, style: .violet600)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.flex.layout(mode: .adjustHeight)

        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    override func attribute() {
        super.attribute()
        titleLabel.do {
            $0.backgroundColor = .red
        }
    }
    
    override func layout() {
        super.layout()
        
        contentView.flex.define { flex in
            flex.addItem(titleLabel).width(100%).height(400)
        }
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
    }
}
