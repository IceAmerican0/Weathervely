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
    
    private var topGreetingLabel = CSLabel(.bold, 25, "날씨블리에 오신 걸\n환영해요!")
    private var logo = UIImageView()
    private var bottomGreetingLabel = CSLabel(.bold, 20, "날씨블리가 날씨에 맞는\n옷차림을 알려드릴 거에요")
    private var startButton = CSButton(.primary)
    
    override func attribute() {
        super.attribute()
        
        logo.do {
            $0.image = UIImage(systemName: "star.fill")
            
        }
        
        startButton.do {
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
    }
    
    override func layout() {
        super.layout()
    
        container.flex
//            .alignItems(.center)
            .justifyContent(.spaceAround)
            .define { flex in
                flex.addItem(topGreetingLabel)
                flex.addItem(logo).width(35%).height(23%).alignSelf(.center)
                flex.addItem(bottomGreetingLabel)
                flex.addItem(startButton)
                    .marginHorizontal(43)
                    .height(startButton.primaryHeight)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        startButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.login("abcde")
                self?.navigationController?.pushViewController(TestViewController(TestViewModel()), animated: true)
                
//                self?.viewModel.login("abcde")
//                self?.navigationController?.pushViewController(SettingRegionViewController(SettingRegionViewModel()), animated: true)
                
            }
        /// ViewModel 생성 X
//            .map { EditNicknameViewController(EditNicknameViewModel())}
//            .bind(to: viewModel.navigationPushViewControllerRelay)
        
        /// ViewModel 생성시
//            .map { [weak self] _ in self?.viewModel.nicknameViewController()}
//            .bind(to: viewModel.navigationPushViewControllerRelay)
//            .disposed(by: bag)
    }

}
