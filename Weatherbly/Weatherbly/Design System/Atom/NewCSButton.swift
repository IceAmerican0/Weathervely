//
//  NewCSTextButton.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import UIKit
import FlexLayout

/*
 
 
 issue 확인해야할 것
 case w 300 h 30 -> CSButton 내에서 지정해줬을떄 -> flex -> 1. 반쪽짜리 2개 가능?
                                                       2. flex 에서 패딩만 줬을 떄, 버튼 크기 조절됌?
 */



final public class NewCSButton: UIButton {
    
    enum Style {
        case violet600
        case violet100
        case white // -> border
    }
    
    init (_ style: Style) {
        super.init(frame: .zero)
//        func buttonstyle()
//        func setradius()
    }
    
    public override func layoutSubviews() {
//        <#code#>
    }

}


