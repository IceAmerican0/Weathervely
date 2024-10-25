//
//  NicknameCompleteViewController.swift
//  Weatherbly
//
//  Created by Khai on 2/22/24.
//

import DesignSystem
import UIKit

final class NicknameCompleteViewController: RxBaseViewController<NicknameCompleteViewModel> {
    private var navigationView = CSNavigationView(.leftButton(.leftArrow_black)).then {
        $0.setTitle("닉네임 확인")
    }
    
    private var explanationLabel = LabelMaker(
        font: .heading_5_B
    ).make(text: "아래 닉네임으로 설정할까요?")
    
    private var guideLabel = LabelMaker(
        font: .body_3_M,
        fontColor: .gray60
    ).make(text: "언제든지 바꿀 수 있어요")
    
    private var nameLabel = LabelMaker(
        font: .body_3_M
    ).make()
    
    private var refuseButton = CSButton(.standard, style: .violet100).then {
        $0.setTitle("아니오", for: .normal)
    }
    
    private var confirmButton = CSButton(.standard, style: .violet600).then {
        $0.setTitle("네", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = viewModel.nickname
    }

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(navigationView)
            $0.addItem(explanationLabel).marginTop(50).marginLeft(20)
            $0.addItem(guideLabel).marginTop(8).marginLeft(20)
            $0.addItem().alignSelf(.stretch).justifyContent(.center).alignItems(.center)
                .marginTop(33).marginHorizontal(20).height(51).backgroundColor(.violet10).define {
                $0.view?.addBorders([.top, .bottom], 1, .violet100)
                $0.addItem(nameLabel)
            }
            $0.addItem().position(.absolute).direction(.row).alignSelf(.stretch)
                .bottom(20).horizontally(20).height(48).define { bottom in
                bottom.addItem(refuseButton).basis(0).grow(1)
                bottom.addItem().width(8)
                bottom.addItem(confirmButton).basis(0).grow(1)
            }
        }
    }
    
    override func bind() {
        super.bind()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }).disposed(by: bag)
        
        refuseButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.didTapRefuseButton()
            }.disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.didTapConfirmButton()
            }.disposed(by: bag)
    }
}
