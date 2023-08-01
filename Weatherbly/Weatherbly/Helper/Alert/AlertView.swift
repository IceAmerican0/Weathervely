//
//  AlertView.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit
import FlexLayout
import PinLayout
import Then

public final class AlertView: UIView {
    private var state: AlertViewState
    
    private let dimView = UIView()
    private let alertContainer = UIView()
    private var titleLabel = CSLabel(.bold, 10, "")
    private var messageLabel = CSLabel(.regular, 10, "")
    
    private let buttonWrapper = UIView()
    private let confirmButton = UIButton()
    
    init(state: AlertViewState) {
        self.state = state
        super.init(frame: UIScreen.main.bounds)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func dismiss(completion: AlertActionHandler?) {
        isHidden = true
        self.subviews.forEach { $0.removeFromSuperview() }
        completion?()
    }
}

private extension AlertView {
    func attribute() {
        dimView.do {
            $0.backgroundColor = CSColor._0__1.color
        }
        
        alertContainer.do {
            $0.backgroundColor = .white
            $0.setCornerRadius(10)
        }
        
        titleLabel.do {
            $0.text = state.title
            $0.isHidden = state.title.isEmpty
        }
        
        messageLabel.do {
            $0.text = state.message
            $0.sizeToFit()
            $0.isHidden = state.message == nil
        }
        
        buttonWrapper.do {
            $0.addBorder(.top)
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.backgroundColor = .white
            $0.titleLabel?.font = .boldSystemFont(ofSize: 16)
            $0.setCornerRadius(10)
        }
    }
    
    func layout() {
        dimView.pin.all()
        dimView.flex.layout()
        
        alertContainer.pin.hCenter().vCenter()
        alertContainer.flex.layout(mode: .adjustHeight)
    }
    
    func contentLayout() {
        dimView.flex.define { flex in
            flex.addItem(alertContainer).width(78%).height(18.5%)
                .define { flex in
                flex.addItem(titleLabel)
                flex.addItem(messageLabel)
                flex.addItem(buttonWrapper).alignItems(.center).justifyContent(.center)
                    .define { flex in
                    flex.addItem(confirmButton).width(78%).height(13%)
                }
            }
        }
    }
}
