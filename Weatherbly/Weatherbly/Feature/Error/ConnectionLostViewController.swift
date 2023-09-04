//
//  ConnectionLostViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit
import FlexLayout
import PinLayout

final class ConnectionLostViewController: RxBaseViewController<EmptyViewModel> {
    private var imageView = UIImageView()
    private var topLabel = CSLabel(.regular, 45, "앗..!")
    private var middleLabel = CSLabel(.bold, 18, "서버가 불안정해요")
    private var bottomLabel = CSLabel(.regular, 14, "죄송해요, 최대한 빨리 이 문제를 해결해볼게요")
    private var retryButton = CSButton(.primary)
    
    override func attribute() {
        super.attribute()
        
        imageView.do {
            $0.image = AssetsImage.connectionLost.image
        }
        
        topLabel.do {
            $0.attributedText = NSMutableAttributedString().regular("앗..!", 45, CSColor._172_107_255)
        }
        
        middleLabel.do {
            $0.attributedText = NSMutableAttributedString().bold("서버가 불안정해요", 18, CSColor.none)
        }
        
        bottomLabel.do {
            $0.attributedText = NSMutableAttributedString().regular("죄송해요, 최대한 빨리 이 문제를 해결해볼게요", 14, CSColor._155_155_155)
        }
        
        retryButton.do {
            $0.setTitle("다시 시도하기", for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).justifyContent(.spaceBetween)
            .define { flex in
            flex.addItem(imageView).width(78%).height(31.5%)
            flex.addItem(topLabel).marginTop(38)
            flex.addItem(middleLabel).marginTop(15)
            flex.addItem(bottomLabel).marginTop(8)
            flex.addItem(retryButton).width(78%).height(62)
        }
        
        retryButton.pin.bottom(10%)
    }
}
