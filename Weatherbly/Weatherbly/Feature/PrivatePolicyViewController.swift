//
//  PrivatePolicyViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/18.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift

final class PrivatePolicyViewController: RxBaseViewController<PrivatePolicyViewModel> {
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private let privatePolicyLabel = UILabel()
    private let labelTapGesture = UITapGestureRecognizer()
    
    override func attribute() {
        super.attribute()
        
        privatePolicyLabel.do {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.addGestureRecognizer(labelTapGesture)
        }
    }
    
    override func layout() {
        super.layout()
        container.flex.alignItems(.center).define { flex in
            flex.addItem(navigationView).width(100%)
            flex.addItem(privatePolicyLabel)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        labelTapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.toPrivatePolicyWebView()
            })
            .disposed(by: bag)
    }
}
