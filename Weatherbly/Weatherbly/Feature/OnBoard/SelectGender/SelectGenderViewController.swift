//
//  SelectGenderViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/22.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class SelectGenderViewController: RxBaseViewController<SelectGenderViewModel> {
    
    // MARK: - Component
    var progressBar = CSProgressView(0.75)
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    
    var headerLabel = UILabel()
    var buttonWrapper = UIView()
    var womanButton = UIButton()
    var manButton = UIButton()

    var acceptButton = CSButton(.primary)
    
    var isFemale = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - View

    override func attribute() {
        super.attribute()
        
        headerLabel.do {
            $0.text = "\(UserDefaultManager.shared.nickname)님의\n성별을 골라주세요"
            $0.font = .boldSystemFont(ofSize: 24)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
        womanButton.do {
            $0.setTitle("여성", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(.white, for: .selected)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 13
            $0.isSelected = true
        }
        
        manButton.do {
            $0.setTitle("남성", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(.white, for: .selected)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 13
        }
        
        setButtonColor()
        
        acceptButton.do {
            $0.setTitle("확인", for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView).width(100%)
            
            flex.addItem(headerLabel)
                .marginTop(27)
            
            flex.addItem(buttonWrapper)
                .direction(.row)
                .marginTop(41)
                .height(58)
                .marginHorizontal(54)
                .define { flex in
                flex.addItem(womanButton)
                        .right(7)
                        .grow(1).shrink(1)
                
                flex.addItem(manButton)
                        .left(7)
                        .grow(1).shrink(1)
            }
            
            flex.addItem(acceptButton)
                .marginHorizontal(43)
                .height(62)
                
        }
        
        acceptButton.pin.bottom(view.pin.safeArea + 5)
    }
    
    override func bind() {
        super.bind()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        womanButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if self?.isFemale == false { self?.buttonToggle() }
            })
            .disposed(by: bag)
        
        manButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if self?.isFemale == true { self?.buttonToggle() }
            })
            .disposed(by: bag)
        
        acceptButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didTapAcceptButton(self?.isFemale == true ? "female" : "male")
            })
            .disposed(by: bag)
    }
    
    private func buttonToggle() {
        womanButton.isSelected.toggle()
        manButton.isSelected.toggle()
        isFemale = womanButton.isSelected
        setButtonColor()
    }
    
    private func setButtonColor() {
        womanButton.backgroundColor = isFemale ? CSColor._151_151_151.color : CSColor._248_248_248.color
        manButton.backgroundColor = isFemale ? CSColor._248_248_248.color : CSColor._151_151_151.color
    }
}
