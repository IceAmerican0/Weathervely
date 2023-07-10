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

final class SelectGenderViewController: BaseViewController {
    
    
    var viewModel = SelectGenderViewModel()
    var bag = DisposeBag()
    
    // MARK: - Component
     var progressBar = UIProgressView()
     var backButton = UIButton()
    
     var headerLabel = UILabel()
     var buttonWrapper = UIView()
     var womanButton = UIButton()
     var manButton = UIButton()
    
     var acceptButton = CSButton(.primary)

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - View

    override func attribute() {
        super.attribute()
        
        progressBar.do {
            $0.progress = 1.0
            $0.progressViewStyle = .default
            $0.progressTintColor = CSColor._151_151_151.color
        }
        
        backButton.do {
            $0.setImage(AssetsImage.navigationBackButton.image, for: .normal)
            $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        }
        
        headerLabel.do {
            $0.text = "(닉네임) 님의\n성별을 골라주세요"
            $0.font = .boldSystemFont(ofSize: 24)
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
        }
        
        womanButton.do {
            $0.setTitle("여성", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.backgroundColor = CSColor._248_248_248.color
            $0.layer.cornerRadius = 13
        }
        
        manButton.do {
            $0.setTitle("남성", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.backgroundColor = CSColor._248_248_248.color
            $0.layer.cornerRadius = 13
        }
        
        acceptButton.do {
            $0.setTitle("확인", for: .normal)
            $0.isEnabled = false
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define { flex in
            flex.addItem(progressBar)
            flex.addItem(backButton)
                .size(44)
                .marginTop(15)
                .left(12)
            
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
        
        acceptButton.pin.bottom(view.pin.safeArea + 20)
    }
    
    override func bind() {
        super.bind()
        
        womanButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if self?.manButton.backgroundColor == CSColor._151_151_151.color {
                    self?.manButton.backgroundColor = CSColor._248_248_248.color
                }
                self?.womanButton.backgroundColor = CSColor._151_151_151.color
            })
            .disposed(by: bag)
        
        manButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if self?.womanButton.backgroundColor == CSColor._151_151_151.color {
                    self?.womanButton.backgroundColor = CSColor._248_248_248.color
                }
                self?.manButton.backgroundColor = CSColor._151_151_151.color
            })
            .disposed(by: bag)
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
