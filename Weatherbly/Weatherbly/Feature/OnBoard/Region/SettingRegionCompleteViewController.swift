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
import Then

public final class SettingRegionCompleteViewController: RxBaseViewController<SettingRegionCompleteViewModel> {
    private let navigationView = CSNavigationView(.leftButton(.leftArrow_black)).then {
        $0.setTitle("동네 설정")
    }
    
    private var comment = LabelMaker(
        font: .heading_5_B
    ).make(text: "선택한 동네로 설정할까요?")
    
    private lazy var region = LabelMaker(
        font: .body_3_M
    ).make(text: "\(viewModel.regionDataRelay.value.address_name ?? "")").then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let negativeButton = CSButton(.standard, style: .violet100).then {
        $0.setTitle("아니오", for: .normal)
    }
    
    private let confirmButton = CSButton(.standard, style: .violet600).then {
        $0.setTitle("네", for: .normal)
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(navigationView)
            $0.addItem(comment).marginTop(50).marginLeft(20)
            $0.addItem().alignSelf(.stretch).alignItems(.center).justifyContent(.center)
                .marginTop(32).marginHorizontal(20).height(51).backgroundColor(.violet10)
                .define {
                    $0.view?.addBorders([.top, .bottom], 1, .violet100)
                    $0.addItem(region)
            }
            $0.addItem().position(.absolute).direction(.row).alignSelf(.stretch)
                .bottom(20).horizontally(20).height(48).define { bottom in
                bottom.addItem(negativeButton).basis(0).grow(1)
                bottom.addItem().width(8)
                bottom.addItem(confirmButton).basis(0).grow(1)
            }
        }
        
        if viewModel.settingRegionState != .onboard {
            navigationView.setTitle("동네 변경 / 추가")
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }).disposed(by: bag)
        
        negativeButton.rx.tap
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.didTapConfirmButton()
            }.disposed(by: bag)
    }
}
