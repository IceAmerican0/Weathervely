//
//  MainToolTipViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/14.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

public protocol MainToolTipViewDelegate: AnyObject {
    func toolTipDismiss()
}

public final class MainToolTipViewController: UIViewController, CodeBaseInitializerProtocol {
    weak var delegate: MainToolTipViewDelegate?
    
    private let container = UIView()
    private let dimView = UIView()
    private let mainBox = UIView()
    private let upperWrapper = UIView()
    private let upperLabel = UILabel()
    private let lowerLabel = UILabel()
    
    private let outerLeftArrow = UIImageView()
    private let innerLeftArrow = UIImageView()
    private let innerRightArrow = UIImageView()
    private let outerRightArrow = UIImageView()
    private let touchImage = UIImageView()
    
    private let topMargin = UIScreen.main.bounds.height * 0.274
    
    private let backgroundTapGesture = UITapGestureRecognizer()
    private let bag = DisposeBag()
    private var touchCount = 0
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dimView)
        view.addSubview(container)
        
        tooltipAnimation()
    }
    
    public override func viewDidLayoutSubviews() {
        dimView.pin.hCenter().bottom()
        dimView.flex.layout()
        container.pin.all()
        container.flex.layout()
        
        layout()
    }
    
    func attribute() {
        container.do {
            $0.addGestureRecognizer(backgroundTapGesture)
        }
        
        dimView.do {
            $0.backgroundColor = CSColor._217_217_217_04.color
            $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        mainBox.do {
            $0.isHidden = true
            $0.layer.borderWidth = 8
            $0.layer.borderColor = CSColor._231_231_231.cgColor
        }
        
        upperLabel.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 20
            $0.layer.masksToBounds = true
            $0.numberOfLines = 1
            $0.textAlignment = .center
            $0.attributedText = NSMutableAttributedString()
                .regular("💡 화면을 좌우로 넘겨보세요", 20, CSColor._255_255_255_1)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        lowerLabel.do {
            $0.numberOfLines = 1
            $0.textAlignment = .center
            $0.attributedText = NSMutableAttributedString()
                .regular("다른 시간대의 날씨와 옷을 볼 수 있어요", 18, CSColor.none)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        outerLeftArrow.do {
            $0.image = AssetsImage.toolTipArrow.image
            $0.transform = $0.transform.rotated(by: .pi / 2)
            $0.alpha = 1.0
        }
        
        innerLeftArrow.do {
            $0.image = AssetsImage.toolTipArrow.image
            $0.transform = $0.transform.rotated(by: .pi / 2)
            $0.alpha = 1.0
        }
        
        innerRightArrow.do {
            $0.image = AssetsImage.toolTipArrow.image
            $0.transform = $0.transform.rotated(by: .pi * 1.5)
            $0.alpha = 1.0
        }
        
        outerRightArrow.do {
            $0.image = AssetsImage.toolTipArrow.image
            $0.transform = $0.transform.rotated(by: .pi * 1.5)
            $0.alpha = 1.0
        }
        
        touchImage.do {
            $0.image = AssetsImage.touchIcon.image
            $0.isHidden = true
            $0.alpha = 0.75
        }
    }
    
    func layout() {
        container.flex.alignItems(.center).define { flex in
            flex.addItem(upperWrapper).direction(.row).alignItems(.center).marginTop(topMargin)
                .define { flex in
                    flex.addItem(outerLeftArrow).width(30).height(40)
                    flex.addItem(innerLeftArrow).width(30).height(40).marginLeft(-15).marginRight(10)
                    flex.addItem(upperLabel).width(67%).height(52)
                    flex.addItem(innerRightArrow).width(30).height(40).marginLeft(10)
                    flex.addItem(outerRightArrow).width(30).height(40).marginLeft(-15)
            }
            flex.addItem(lowerLabel).marginTop(13).marginHorizontal(10).width(86%)
            flex.addItem(mainBox).width(UIScreen.main.bounds.width * 0.55).height(44)
            flex.addItem(touchImage).size(90)
        }
        
        if UIScreen.main.bounds.width < 376 {
            dimView.pin.top(UIScreen.main.bounds.height * 0.41)
        } else {
            dimView.pin.top(UIScreen.main.bounds.height * 0.4)
        }
        
        mainBox.pin.hCenter().top(view.pin.safeArea.top).margin(7)
    }
    
    func bind() {
        backgroundTapGesture.rx
            .event
            .subscribe(onNext: { [weak self] _ in
                self?.touchCount += 1
                switch self?.touchCount {
                case 1:
                    self?.upperLabel.text = "💡 상단 영역을 클릭해보세요"
                    self?.lowerLabel.text = "현재 날씨 / 내일 날씨로 빠르게 이동할 수 있어요"
                    self?.touchImage.pin.top(8%).left(60%)
                    self?.mainBox.isHidden = false
                    self?.touchImage.isHidden = false
                    self?.outerLeftArrow.isHidden = true
                    self?.innerLeftArrow.isHidden = true
                    self?.outerRightArrow.isHidden = true
                    self?.innerRightArrow.isHidden = true
                case 2:
                    self?.upperLabel.text = "💡 양 옆 카드를 클릭해보세요"
                    self?.lowerLabel.text = "더 자세히 볼 수 있어요"
                    self?.mainBox.isHidden = true
                    self?.touchImage.pin.top(53%).left(4%)
                    if UIScreen.main.bounds.width < 376 {
                        self?.dimView.pin.hCenter().top().marginTop(-(UIScreen.main.bounds.height * 0.59))
                    } else {
                        self?.dimView.pin.hCenter().top().marginTop(-(UIScreen.main.bounds.height * 0.6))
                    }
                case 3:
                    self?.upperLabel.text = "💡 '너의 온도는?' 버튼을 클릭해보세요"
                    self?.upperLabel.pin.hCenter().width(85%)
                    self?.lowerLabel.text = "체감온도에 맞게 옷 겹수를 바꿀 수 있어요"
                    if UIScreen.main.bounds.width < 376 {
                        self?.touchImage.pin.top(91%).right(12%)
                        self?.dimView.pin.hCenter().top().marginTop(-(UIScreen.main.bounds.height * 0.12))
                    } else {
                        self?.touchImage.pin.top(89%).right(12%)
                        self?.dimView.pin.hCenter().top().marginTop(-(UIScreen.main.bounds.height * 0.14))
                    }
                default:
                    self?.delegate?.toolTipDismiss()
                    self?.dismiss(animated: false)
                }
            })
            .disposed(by: bag)
    }
    
    private func tooltipAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       animations: {
            self.touchImage.alpha = 0.5
            self.innerLeftArrow.alpha = 0.5
            self.innerRightArrow.alpha = 0.5
            self.outerLeftArrow.alpha = 0.5
            self.outerRightArrow.alpha = 0.5
            self.view.layoutIfNeeded()
        }) { _ in
            UIView.animate(withDuration: 0.5,
                           delay: 0.5,
                           animations: {
                self.touchImage.alpha = 1.0
                self.innerLeftArrow.alpha = 1.0
                self.innerRightArrow.alpha = 1.0
                self.outerLeftArrow.alpha = 1.0
                self.outerRightArrow.alpha = 1.0
                self.view.layoutIfNeeded()
            }) { _ in
                self.tooltipAnimation()
            }
        }
    }
}
