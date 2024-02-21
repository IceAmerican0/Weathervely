//
//  SettingRegionCompleteViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/24.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

public final class SettingRegionCompleteViewController: RxBaseViewController<SettingRegionCompleteViewModel> {
    
    private let progressBar = CSProgressView(0.66)
    private let navigationView = CSNavigationView(.leftButton(.navi_back))
    private var explanationLabel = CSLabel(.bold, 24, "선택한 동네로 설정할까요?")
    
    private let regionWrapper = UIView()
    private var regionLabel = CSLabel(.regular, 20, "서울특별시 송파구 풍납4동")
    
    private let buttonWrapper = UIView()
    private let negativeButton = CSButton(.grayFilled)
    private let confirmButton = CSButton(.primary)
    
    override func attribute() {
        super.attribute()
        
        regionWrapper.do {
            $0.backgroundColor = CSColor._248_248_248.color
            $0.addBorder(.top)
            $0.addBorder(.bottom)
        }
        
        regionLabel.do {
            $0.attributedText = NSMutableAttributedString().regular(viewModel.regionDataRelay.value.address_name!, 20, CSColor.none)
            $0.adjustsFontSizeToFitWidth = true
        }
        
        negativeButton.do {
            $0.setTitle("아니요", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
            $0.backgroundColor = CSColor._151_151_151.color
            $0.setTitleColor(.white, for: .normal)
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView).width(UIScreen.main.bounds.width)
            flex.addItem(explanationLabel).marginTop(13%).width(65%).height(34)
            flex.addItem(regionWrapper).alignItems(.center).justifyContent(.center)
                .marginTop(27).marginHorizontal(20).width(89%).height(55)
                .define { flex in
                    flex.addItem(regionLabel).marginHorizontal(14).width(81.5%).height(28)
            }
            flex.addItem(buttonWrapper).position(.absolute).direction(.row).justifyContent(.center).bottom(22%).width(100%)
                .define { flex in
                flex.addItem(negativeButton).width(39%).height(62)
                flex.addItem(confirmButton).marginLeft(22).width(39%).height(62)
            }
        }
        
        if viewModel.settingRegionState != .onboard {
            progressBar.isHidden = true
            navigationView.setTitle("동네 변경 / 추가")
            navigationView.addBorder(.bottom)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        negativeButton.rx.tap
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.didTapConfirmButton()
            }
            .disposed(by: bag)
    }
}
