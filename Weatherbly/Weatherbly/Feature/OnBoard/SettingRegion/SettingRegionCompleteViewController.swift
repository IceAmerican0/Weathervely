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
    
    private let progressBar = CSProgressView(0.5)
    private let navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private var explanationLabel = CSLabel(.bold, 24, "선택한 동네로 설정할까요?")
    
    private let regionWrapper = UIView()
    private var regionLabel = CSLabel(.regular, 20, "서울특별시 송파구 풍납4동")
    
    private let buttonWrapper = UIView()
    private let negativeButton = CSButton(.grayFilled)
    private let confirmButton = CSButton(.primary)
    
    private var regionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let explanationMarginTop = UIScreen.main.bounds.height * 0.13
    private let explanationWidth = UIScreen.main.bounds.width * 0.65
    private let regionWrapperWidth = UIScreen.main.bounds.width * 0.89
    private let regionWidth = UIScreen.main.bounds.width * 0.815
    private let wrapperMarginTop = UIScreen.main.bounds.height * 0.26
    private let buttonWidth = UIScreen.main.bounds.width * 0.39
    
    var isFromEdit = false
    
    override func attribute() {
        super.attribute()
        
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
            flex.addItem(explanationLabel).marginTop(explanationMarginTop).width(explanationWidth).height(34)
            flex.addItem(regionWrapper).alignItems(.center)
                .marginTop(27).marginHorizontal(20).width(regionWrapperWidth).height(55)
                .define { flex in
                flex.addItem(regionLabel).marginHorizontal(14).width(regionWidth).height(28)
            }
            flex.addItem(buttonWrapper).direction(.row).alignItems(.center)
                .marginTop(wrapperMarginTop).marginHorizontal(32)
                .define { flex in
                flex.addItem(negativeButton).width(buttonWidth).height(62)
                flex.addItem(confirmButton).marginLeft(22).width(buttonWidth).height(62)
            }
        }
        
        if isFromEdit {
            progressBar.isHidden = true
        }
    }
    
    override func viewBinding() {
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        negativeButton.rx.tap
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(onNext: viewModel.didTapConfirmButton)
            .disposed(by: bag)
    }
}
