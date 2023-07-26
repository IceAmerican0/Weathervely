//
//  TestViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/25.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class TestViewController: RxBaseViewController<TestViewModel> {
    
    var button = CSButton(.primary)
    var textView = UITextView()
    
    override func attribute() {
        super.attribute()
        
        button.do {
            $0.setTitle("test", for: .normal)
        }
        
        textView.do {
            $0.backgroundColor = .yellow
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex
            .define { flex in
                flex.addItem(button)
                flex.addItem(textView).height(30%)
            }
    }
    
    override func bind() {
        super.bind()
        
        button.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.testRequest("abcde")
            }
        .disposed(by: bag)    }
}
