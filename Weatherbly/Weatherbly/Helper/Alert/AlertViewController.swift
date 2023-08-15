//
//  AlertViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift

final class AlertViewController: UIViewController, CodeBaseInitializerProtocol {
    private var state: AlertViewState
    
    private let dimView = UIView()
    private let alertContainer = UIView()
    private var titleLabel = CSLabel(.bold, 19, "")
    private var messageLabel = CSLabel(.regular, 19, "")
    
    private let buttonWrapper = UIView()
    private let confirmButton = UIButton()
    
    let bag = DisposeBag()
//    private let backgroundTapGesture = UITapGestureRecognizer()
    private var closeAction: (() -> Void) = ({})
    
    private let alertWidth = UIScreen.main.bounds.width * 0.78
    private let labelWidth = UIScreen.main.bounds.width * 0.64
    
    init(state: AlertViewState) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
        
        codeBaseInitializer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dimView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    func layout() {
        dimView.pin.all()
        dimView.flex.layout()
        
        alertContainer.pin.hCenter().vCenter()
        alertContainer.flex.layout(mode: .adjustHeight)
        
        contentLayout()
    }
    
    func attribute() {
        dimView.do {
            $0.backgroundColor = CSColor._0__065.color
//            $0.addGestureRecognizer(backgroundTapGesture)
        }
        
        alertContainer.do {
            $0.backgroundColor = .white
            $0.setCornerRadius(10)
        }
        
        titleLabel.do {
            $0.attributedText = NSMutableAttributedString().bold(state.title, 19, CSColor._172_107_255)
            $0.sizeToFit()
            $0.isHidden = state.title.isEmpty
        }
        
        messageLabel.do {
            if let msg = state.message {
                $0.attributedText = NSMutableAttributedString().bold(msg, 19, CSColor.none)
            } else {
                $0.isHidden = true
            }
            $0.sizeToFit()
        }
        
        buttonWrapper.do {
            $0.addBorder(.top)
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setCornerRadius(10)
        }
    }
    
    func contentLayout() {
        dimView.flex.addItem(alertContainer).alignItems(.center)
            .width(alertWidth).height(18.5%)
            .define { flex in
            flex.addItem(titleLabel).marginTop(24).width(labelWidth).height(20)
            flex.addItem(messageLabel).marginTop(10).width(labelWidth).height(20)
            flex.addItem(buttonWrapper).marginTop(25).define { flex in
                flex.addItem(confirmButton).width(alertWidth).height(55)
            }
        }
        if state.message == nil {
            titleLabel.pin.top(40)
        }
    }
    
    func bind() {
        // TODO: 백그라운드 터치시 알럿 지우기 추후 고민
//        backgroundTapGesture.rx
//            .event
//            .subscribe(onNext: { _ in
//                self.dismiss(animated: false)
//            })
//            .disposed(by: bag)
        
        confirmButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: false)
            })
            .disposed(by: bag)
    }
}
