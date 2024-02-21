//
//  CSSwitch.swift
//  Weatherbly
//
//  Created by Khai on 2/7/24.
//

import UIKit
import PinLayout
import Then
import RxRelay

public final class CSSwitch: UIControl {
    public lazy var isSelectedRelay = BehaviorRelay(value: isSelected)
    
    private lazy var thumb = UIView().then {
        $0.clipsToBounds = true
        $0.setCornerRadius(10)
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var bar = UIView().then {
        $0.clipsToBounds = true
        $0.setCornerRadius(7)
        $0.isUserInteractionEnabled = false
    }
    
    public override var isSelected: Bool {
        didSet {
            thumbAnimation()
            isSelectedRelay.accept(isSelected)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: 44, height: 29)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if isTouchInside, isEnabled {
            isSelected.toggle()
        }
    }
}

private extension CSSwitch {
    func setLayout() {
        backgroundColor = .clear
        clipsToBounds = true
        addSubview(bar)
        addSubview(thumb)
    }
    
    func layout() {
        bar.pin.vCenter().hCenter().width(38).height(14)
        
        if isSelected {
            thumb.pin.vCenter().right(2).size(20)
        } else {
            thumb.pin.vCenter().left(2).size(20)
        }
    }
    
    func updateColor() {
        if isSelected {
            bar.backgroundColor = .violet150
            thumb.backgroundColor = .violet600
        } else {
            bar.backgroundColor = .gray30
            thumb.backgroundColor = .gray60
        }
    }
    
    func thumbAnimation() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseIn
        ) {
            self.layout()
            self.updateColor()
        }
    }
}
