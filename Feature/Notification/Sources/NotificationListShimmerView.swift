//
//  NotificationListShimmerView.swift
//  Weatherbly
//
//  Created by Khai on 6/18/24.
//

import UIKit
import FlexLayout
import PinLayout

public final class NotificationListShimmerView: UIView {
    public init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        flex.layout()
    }
}

private extension NotificationListShimmerView {
    func layout() {
        flex.marginTop(0).paddingTop(16).paddingHorizontal(20).define {
            for _ in 0..<5 {
                $0.addItem().direction(.row).justifyContent(.spaceBetween).paddingVertical(18).height(97).define {
                    $0.addItem(shimmer(20)).size(40)
                    $0.addItem().define {
                        $0.addItem(shimmer(10)).width(64).height(17)
                        $0.addItem(shimmer(10)).marginTop(4).width(130).height(19)
                        $0.addItem(shimmer(10)).marginTop(4).width(190).height(17)
                    }
                    $0.addItem(shimmer(10)).width(56).height(17)
                }
            }
            $0.addItem(shimmer(12)).marginTop(16).alignSelf(.stretch).height(40)
        }
    }
}
