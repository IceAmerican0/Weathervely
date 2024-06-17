//
//  HomeShimmerView.swift
//  Weatherbly
//
//  Created by Khai on 6/17/24.
//

import UIKit
import FlexLayout
import PinLayout

public final class HomeShimmerView: UIView {
    private let topShimmer = ShimmerView()
    private let timeShimmer = ShimmerView()
    private let forecastShimmer = ShimmerView()
    private let firstFilterShimmer = ShimmerView()
    private let secondFilterShimmer = ShimmerView()
    private let filterButtonShimmer = ShimmerView()
    private let itemShimmer1 = ShimmerView()
    private let itemShimmer2 = ShimmerView()
    private let itemShimmer3 = ShimmerView()
    private let itemShimmer4 = ShimmerView()
    
    private let width = (Constants.screenWidth - 60) / 2
    
    public init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
}

private extension HomeShimmerView {
    func setLayout() {
        addSubview(topShimmer)
        addSubview(timeShimmer)
        addSubview(forecastShimmer)
        addSubview(firstFilterShimmer)
        addSubview(secondFilterShimmer)
        addSubview(filterButtonShimmer)
        addSubview(itemShimmer1)
        addSubview(itemShimmer2)
        addSubview(itemShimmer3)
        addSubview(itemShimmer4)
    }
    
    func layout() {
        topShimmer.setCornerRadius(12).pin.top(12).horizontally(20).height(20)
        timeShimmer.setCornerRadius(12).pin.below(of: topShimmer).marginTop(12).horizontally(20).height(20)
        forecastShimmer.setCornerRadius(12).pin.below(of: timeShimmer).marginTop(14).horizontally(20).height(150)
        
        firstFilterShimmer.setCornerRadius(14.5).pin.below(of: forecastShimmer).marginTop(14).left(20).width(80).height(29)
        secondFilterShimmer.setCornerRadius(14.5).pin.after(of: firstFilterShimmer, aligned: .top).marginLeft(8).width(80).height(29)
        filterButtonShimmer.setCornerRadius(14.5).pin.below(of: forecastShimmer).marginTop(14).right(20).size(29)
        
        itemShimmer1.setCornerRadius(12).pin.below(of: firstFilterShimmer).marginTop(13).left(20).width(width).height(158)
        itemShimmer2.setCornerRadius(12).pin.after(of: itemShimmer1, aligned: .top).marginLeft(20).width(width).height(236)
        itemShimmer3.setCornerRadius(12).pin.below(of: itemShimmer1).marginTop(20).left(20).width(width).height(236)
        itemShimmer4.setCornerRadius(12).pin.below(of: itemShimmer2).marginTop(20).right(20).width(width).height(236)
    }
}
