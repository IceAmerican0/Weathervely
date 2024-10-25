//
//  TenDaysForecastShimmerView.swift
//  Weatherbly
//
//  Created by Khai on 6/17/24.
//

import DesignSystem
import UIKit

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
        flex.layout()
    }
}

private extension TendaysForecastShimmerView {
    func layout() {
        flex.paddingHorizontal(20).define {
            for _ in 0..<10 {
                $0.addItem(shimmer(20)).marginTop(21).alignSelf(.stretch).height(40)
            }
        }
    }
}
