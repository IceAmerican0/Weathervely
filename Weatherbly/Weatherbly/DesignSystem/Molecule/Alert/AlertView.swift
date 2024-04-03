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
    
    private var buttonContainer = UIView()
    
    private let confirmButton = UIButton().then {
        $0.backgroundColor = .violet600
        $0.titleLabel?.font = .body_1_B
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private let cancelButton = UIButton().then {
        $0.setCornerRadius(16, [.bottomRight])
        $0.backgroundColor = .violet600
        $0.titleLabel?.font = .body_1_B
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
        setButtonList()
        
        flex.addItem(dimView).paddingHorizontal(53).define {
            $0.addItem(alertContainer).justifyContent(.center).alignItems(.center).define {
                $0.addItem(image).marginTop(34).size(88)
                $0.addItem(message.then {
                    $0.text = state.title
                }).marginTop(24).marginHorizontal(20)
                $0.addItem(buttonContainer).marginTop(24).alignSelf(.stretch).height(48)
            }
        }
    }
    
    func bind() {
        // 버튼 두개일시 왼쪽 버튼
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss()
                
                switch owner.state.buttonListState {
                case .single:
                    owner.state.closeAction?()
                case .double(let left, let right):
                    left.action?()
                }
            }.disposed(by: bag)
        
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss()
                
                switch owner.state.buttonListState {
                case .single:
                    owner.state.closeAction?()
                case .double(let left, let right):
                    right.action?()
                }
            }.disposed(by: bag)
    }
    
    func setButtonList() {
        switch state.buttonListState {
        case .single:
            confirmButton.setCornerRadius(16, [.bottomLeft, .bottomRight])
            buttonContainer.flex.addItem(confirmButton).grow(1)
        case .double(let left, let right):
            confirmButton.setCornerRadius(16, [.bottomLeft])
            confirmButton.setTitle(left.title, for: .normal)
            cancelButton.setTitle(right.title, for: .normal)
            
            buttonContainer.flex.direction(.row).define {
                $0.addItem(confirmButton).basis(0).grow(1)
                $0.addItem().backgroundColor(.white).width(1)
                $0.addItem(cancelButton).basis(0).grow(1)
            }
        }
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
}
