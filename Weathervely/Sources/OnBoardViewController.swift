//
//  OnBoardViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/06.
//

import DesignSystem
import UIUtil
import ResourcePackage
import UIKit
import PinLayout

public final class OnBoardViewController: RxBaseViewController<OnBoardViewModel> {
    
    private var logo = UIImageView().then {
        $0.image = .logo_color
    }
    
    private var topLabel = LabelMaker(
        font: .body_1_M
    ).make(text: "날씨와 스타일까지 쿨하게")
    
    private var middleLabel = LabelMaker(
        font: .heading_3_B,
        fontColor: .violet600
    ).make(text: "웨더블리")
    
    private var bottomLabel = LabelMaker(
        font: .body_3_M,
        fontColor: .gray155
    ).make(text: "체감 온도에 맞는 스타일을 추천 받아보세요!")
    
    private var startButton = CSButton(.standard, style: .violet600).then {
        $0.setTitle("시작하기", for: .normal)
    }
    
    private var backgroundLogo = UIImageView().then {
        $0.image = .logo_violet_bg
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(
            logo,
            topLabel,
            middleLabel,
            bottomLabel,
            startButton,
            backgroundLogo
        )
        
        userDefault.set(true, forKey: UserDefaultKey.isOnboard.rawValue)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        middleLabel.pin.hCenter().vCenter().sizeToFit()
        topLabel.pin.above(of: middleLabel).marginBottom(8).hCenter().sizeToFit()
        logo.pin.above(of: topLabel).marginBottom(20).hCenter().size(160)
        bottomLabel.pin.below(of: middleLabel).marginTop(100).hCenter().sizeToFit()
        startButton.pin.below(of: bottomLabel).marginTop(20).horizontally(52).height(48)
        backgroundLogo.pin.bottomRight().width(100%).aspectRatio()
    }
    
    public override func viewBinding() {
        super.viewBinding()
        
        startButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.toNicknameView()
            }
            .disposed(by: bag)
    }
}
