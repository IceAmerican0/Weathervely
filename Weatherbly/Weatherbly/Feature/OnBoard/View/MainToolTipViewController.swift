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

public final class MainToolTipViewController: UIViewController, CodeBaseInitializerProtocol {
    
    private let dimView = UIView()
    private let upperWrapper = UIView()
    private let upperLabel = UILabel()
    private let lowerLabel = UILabel()
    
    private let outerLeftArrow = UIImageView()
    private let innerLeftArrow = UIImageView()
    private let innerRightArrow = UIImageView()
    private let outerRightArrow = UIImageView()
    
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
    }
    
    public override func viewDidLayoutSubviews() {
        dimView.pin.all()
        dimView.flex.layout()
        
        layout()
    }
    
    func attribute() {
        dimView.do {
            $0.backgroundColor = CSColor._0__085.color
            $0.addGestureRecognizer(backgroundTapGesture)
        }
        
        upperLabel.do {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 35
            $0.numberOfLines = 1
            $0.textAlignment = .center
            $0.attributedText = NSMutableAttributedString()
                .regular("💡 화면을 좌우로 넘겨보세요", 20, CSColor._255_255_255_1)
        }
        
        lowerLabel.do {
            $0.numberOfLines = 1
            $0.textAlignment = .center
            $0.attributedText = NSMutableAttributedString()
                .regular("다른 시간대의 날씨와 옷을 볼 수 있어요", 18, CSColor.none)
        }
        
        outerLeftArrow.do {
            $0.image = AssetsImage.toolTipArrow.image
            $0.transform = $0.transform.rotated(by: .pi / 2)
        }
        
        innerLeftArrow.do {
            $0.image = AssetsImage.toolTipArrow.image
            $0.transform = $0.transform.rotated(by: .pi / 2)
        }
        
        innerRightArrow.do {
            $0.image = AssetsImage.toolTipArrow.image
            $0.transform = $0.transform.rotated(by: .pi * 1.5)
        }
        
        outerRightArrow.do {
            $0.image = AssetsImage.toolTipArrow.image
            $0.transform = $0.transform.rotated(by: .pi * 1.5)
        }
    }
    
    func layout() {
        dimView.flex.alignItems(.center).define { flex in
            flex.addItem(upperWrapper).direction(.row).alignItems(.center).marginTop(topMargin)
                .define { flex in
                    flex.addItem(outerLeftArrow).width(30).height(40)
                    flex.addItem(innerLeftArrow).width(30).height(40).marginLeft(-15).marginRight(10)
                    flex.addItem(upperLabel).width(67%).height(52)
                    flex.addItem(innerRightArrow).width(30).height(40).marginLeft(10)
                    flex.addItem(outerRightArrow).width(30).height(40).marginLeft(-15)
            }
            flex.addItem(lowerLabel).marginTop(13)
        }
    }
    
    func bind() {
        backgroundTapGesture.rx
            .event
            .subscribe(onNext: { _ in
                switch self.touchCount {
                case 0:
                    self.touchCount += 1
                    self.upperLabel.text = "💡 양 옆 카드를 클릭해보세요"
                    self.lowerLabel.text = "더 자세히 볼 수 있어요"
                    self.outerLeftArrow.isHidden = true
                    self.innerLeftArrow.isHidden = true
                    self.outerRightArrow.isHidden = true
                    self.innerRightArrow.isHidden = true
                case 1:
                    self.dismiss(animated: false)
                default:
                    self.dismiss(animated: false)
                }
            })
            .disposed(by: bag)
    }
}
