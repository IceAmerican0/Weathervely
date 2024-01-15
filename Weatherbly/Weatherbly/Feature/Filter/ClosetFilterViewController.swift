//
//  ClosetFilterViewController.swift
//  Weatherbly
//
//  Created by Khai on 1/15/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxCocoa

final class ClosetFilterViewController: RxBaseViewController<ClosetFilterViewModel> {
    
    let segmentView = UnderlineTitleSegmentView()
    
    private let resetButton = NewCSButton(.standard, style: .violet600).then {
        $0.imageView?.image = .filter_reset_dis
        $0.backgroundColor = .gray30
    }
    
    private let confirmButton = NewCSButton(.standard, style: .violet600)

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(segmentView).horizontally(20).marginTop(4).height(48).grow(1)
            $0.addItem().direction(.row).width(100%).define {
                $0.addItem(resetButton).marginLeft(20).width(72).height(48)
                $0.addItem(confirmButton).marginRight(20).height(48).grow(1)
            }
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        
    }
}
