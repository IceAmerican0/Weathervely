//
//  AlertView.swift
//  Weatherbly
//
//  Created by Khai on 2/16/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift

final class AlertView: UIView {
    private let dimView = UIView().then {
        $0.backgroundColor = .dim68
    }
    
    private let alertContainer = UIView().then {
        $0.backgroundColor = .white
        $0.setCornerRadius(16)
    }
    
    private let image = UIImageView().then {
        $0.image = .loadError
    }
    
    private var message = LabelMaker(
        font: .body_1_M,
        alignment: .center
    ).make()
    
    private let confirmButton = UIButton().then {
        $0.setCornerRadius(16, [.bottomLeft, .bottomRight])
        $0.backgroundColor = .violet600
        $0.titleLabel?.font = .body_1_B
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    let bag = DisposeBag()
    
    private var state: AlertViewState
    
    init(state: AlertViewState) {
        self.state = state
        super.init(frame: UIScreen.main.bounds)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    func setLayout() {
        dimView.pin.all()
        dimView.flex.layout()
        
        alertContainer.pin.hCenter().vCenter()
        alertContainer.flex.layout(mode: .adjustHeight)
    }
    
    func layout() {
        flex.addItem(dimView).paddingHorizontal(53).define {
            $0.addItem(alertContainer).justifyContent(.center).alignItems(.center).define {
                $0.addItem(image).marginTop(34).size(88)
                $0.addItem(message.then {
                    $0.text = state.title
                }).marginTop(24).marginHorizontal(20)
                $0.addItem(confirmButton).marginTop(24).alignSelf(.stretch).height(48)
            }
        }
    }
    
    func bind() {
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss()
                owner.state.closeAction?()
            }.disposed(by: bag)
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
}
