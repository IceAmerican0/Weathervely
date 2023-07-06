//
//  CSNavigationView.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/05.
//

import UIKit
import FlexLayout
import PinLayout
import UIViewBorders

class CSNavigationView: UIView, CodeBaseInitializerProtocol {
    
    // MARK: - UI Component

//    var height = UIScreen.main.bounds.height * 0.078
    private let wrapperView = UIView()
    private var leftButton = UIButton()
    private var titleLabel = CSLabel(.bold)
    private var rightButton: UIButton?
    
    // MARK: - Control Property
    enum ButtonLayout {
        case leftButton(UIImage?)
        case rightButton(UIImage?, UIImage?)    /// rightButton은 leftButton과 rightButton하나를 가진다.
    }
    private var navigationViewHeight = UIScreen.main.bounds.height * 0.08
    
    init(_ option: ButtonLayout) {
        super.init(frame: CGRect.zero)
        generateButton(option)
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateButton(_ option: ButtonLayout) {
        print(#function)
        switch option {
        case .leftButton(let image):
            
            leftButton.setImage(image, for: .normal)
            
        case .rightButton(let leftImage, let rightImage):
            
            leftButton.setImage(leftImage, for: .normal)
            
            if rightButton == nil {
                rightButton = UIButton()
            }
            if let image = rightImage {
                rightButton?.setImage(image, for: .normal)
                rightButton?.imageView?.contentMode = .scaleAspectFill
            }
            
        }
    }
    
    func attribute() {
        self.backgroundColor = .white
        titleLabel.textAlignment = .center
    }
    
    
    
    func layout() {
        
        self.addSubview(wrapperView)
        wrapperView.pin.all()
        wrapperView.flex.layout()
      
        titleLabelAndButtonLayout()
    }
    
    func titleLabelAndButtonLayout() {
        
        
        wrapperView.flex
            .height(navigationViewHeight)
            .direction(.row).define { flex in
            flex.addItem(leftButton)
                    .marginLeft(12)
                    .marginRight(24)
                    .size(44)
                    .marginVertical((navigationViewHeight - 44) / 2)
                    
            flex.addItem(titleLabel)
                .width(UIScreen.main.bounds.width - 160)
                .backgroundColor(.yellow)
                .backgroundColor(.clear)
                
                if let rightButton = rightButton {
                    flex.addItem(rightButton)
                        .margin(7.2, 12, 15, 23)
                        .size(44)
                }
            
            }
            .view?.addBorder(.bottom)
        
        
    }
    
    func setTitle(_ text: String) {
        print(#function)
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.text = text
    }
    
    func setHeight(_ newHeight: CGFloat) {
        wrapperView.pin.height(newHeight)
    }
}
