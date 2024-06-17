//
//  TenDaysForecastShimmerView.swift
//  Weatherbly
//
//  Created by Khai on 6/17/24.
//

import UIKit
import FlexLayout
import PinLayout

public final class TendaysForecastShimmerView: UIView {
    public init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        pin.all()
        flex.layout()
    }
}

private extension TendaysForecastShimmerView {
    func layout() {
        flex.define { flex in
            for _ in 0..<10 {
                flex.addItem(ShimmerView().setCornerRadius(20)).marginTop(21).marginHorizontal(20).height(40).grow(1)
            }
        }
    }
}
