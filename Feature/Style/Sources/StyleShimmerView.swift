//
//  StyleShimmerView.swift
//  Weatherbly
//
//  Created by Khai on 6/18/24.
//

import DesignSystem
import UIKit
import FlexLayout

public final class StyleShimmerView: UIView {
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

private extension StyleShimmerView {
    func layout() {
        flex.paddingTop(12).paddingLeft(20).define {
            $0.addItem(shimmer(12)).width(80).height(22)
            $0.addItem(shimmer(12)).marginTop(18).marginRight(20).alignSelf(.stretch).height(80)
            $0.addItem().direction(.row).marginTop(13).define {
                for _ in 0..<4 {
                    $0.addItem(shimmer(14.5)).marginRight(12).width(66).height(29)
                }
            }
            
            $0.addItem().direction(.row).marginTop(17).define {
                $0.addItem(shimmer(14.5)).width(80).height(29)
                $0.addItem(shimmer(14.5)).marginLeft(8).width(64).height(29)
                $0.addItem(shimmer(14.5)).marginLeft(8).width(114).height(29)
            }
            $0.addItem().direction(.row).marginTop(8).define {
                $0.addItem(shimmer(14.5)).width(72).height(29)
                $0.addItem(shimmer(14.5)).marginLeft(8).width(114).height(29)
                $0.addItem(shimmer(14.5)).marginLeft(8).width(120).height(29)
            }
            
            $0.addItem().direction(.row).marginTop(17).define {
                $0.addItem(shimmer(14.5)).width(80).height(29)
            }
            
            $0.addItem().direction(.row).marginTop(20).define {
                for _ in 0..<3 {
                    $0.addItem().marginRight(16).define {
                        for _ in 0..<2 {
                            $0.addItem(shimmer(12)).marginBottom(12).width(120).height(180)
                            $0.addItem(shimmer(8)).width(40).marginBottom(12).height(17)
                        }
                    }
                }
            }
            
        }
    }
}
