//
//  OnBoardViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxRelay
import RxCocoa

final class OnBoardViewController: RxBaseViewController<OnBoardViewModel> {
    
    private var topGreetingLabel = CSLabel(.bold, 25, "웨더블리에 오신 걸\n환영해요!")
    private var logo = UIImageView()
    private var bottomGreetingLabel = CSLabel(.bold, 20, "웨더블리가 날씨에 맞는\n옷차림을 알려드릴 거에요")
    private var startButton = CSButton(.primary)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault.set(true, forKey: UserDefaultKey.isOnboard.rawValue)
    }
    
    override func attribute() {
        super.attribute()
        
        logo.do {
            $0.setAssetsImage(AssetsImage.mainLogo)
            $0.setCornerRadius(20)
            $0.setShadow(CGSize(width: 0, height: 4), UIColor.black.cgColor, 0.25, 2)
        }
        
        startButton.do {
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
    }
    
    override func layout() {
        super.layout()
    
        container.flex
            .justifyContent(.spaceAround)
            .define { flex in
                flex.addItem(topGreetingLabel)
                flex.addItem(logo).width(43.5%).height(23%).alignSelf(.center)
                flex.addItem(bottomGreetingLabel)
                flex.addItem(startButton)
                    .marginHorizontal(43)
                    .height(startButton.primaryHeight)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        startButton.rx.tap
            .bind(onNext: viewModel.toNicknameView)
            .disposed(by: bag)
    }

}
