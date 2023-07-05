//
//  CSNavigationView.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/05.
//

import UIKit
import FlexLayout
import PinLayout

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
        case rightButton(UIImage?)    /// rightButton은 leftButton과 rightButton하나를 가진다.
    }
    private var navigationViewHeight = UIScreen.main.bounds.height * 0.078
    
    init(_ option: ButtonLayout) {
        super.init(frame: CGRect.zero)
        generateButton(option)
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateButton(_ option: ButtonLayout) {
        
        switch option {
        case .leftButton(let image):
            if leftButton == nil {
                leftButton = UIButton()
            }
            leftButton?.setImage(image, for: .normal)
            
        case .rightButton(let image):
            if rightButton == nil {
                rightButton = UIButton()
            }
            if let image = image {
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
        wrapperView.pin.height(navigationViewHeight)
        wrapperView.addBorder(.bottom)
        titleLabel.pin
            .top(to: wrapperView.edge.top)
            .bottom(to: wrapperView.edge.bottom)
            .width(UIScreen.main.bounds.width - 160)
        
        titleLabelAndButtonLayout()
        
    }
    
    func titleLabelAndButtonLayout() {
        
            wrapperView.addSubview(leftButton)
            leftButton.pin.size(44)
            leftButton.pin.top(7.2).left(12).bottom(15).right(24)
//            leftButton.pin.vCenter()
        
        if let rightButton = rightButton {
            wrapperView.addSubview(rightButton)
            leftButton.pin.top(7.2).left(23).bottom(15).right(12)
            rightButton.pin.size(44)
            rightButton.pin.top(6.2).left(12).bottom(15).right(23)
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.text = text
    }
    
}
