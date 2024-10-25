//
//  DetailShimmerView.swift
//  Weatherbly
//
//  Created by Khai on 6/18/24.
//

import DesignSystem
import UIKit
import FlexLayout

public final class DetailShimmerView: UIView {
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

private extension DetailShimmerView {
    func layout() {
        flex.paddingTop(10).define {
            $0.addItem(ShimmerView().setCornerRadius(10)).marginLeft(20).width(100).height(24)
            $0.addItem(ShimmerView()).marginTop(10).alignSelf(.stretch).height(562)
            $0.addItem(ShimmerView().setCornerRadius(10)).marginTop(30).marginLeft(20).width(130).height(24)
            
            $0.addItem().direction(.row).marginTop(11.5).define {
                for _ in 0..<3 {
                    $0.addItem(ShimmerView().setCornerRadius(12)).marginLeft(20).width(120).height(180)
                }
            }
        }
    }
}
