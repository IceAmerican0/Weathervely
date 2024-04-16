//
//  CSTextField.swift
//  Weatherbly
//
//  Created by Khai on 2/22/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then

public final class CSTextField: UITextField {
    var bag = DisposeBag()
    
    public var padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    public var isError: BehaviorRelay<Bool> = .init(value: false)
    
    public var errorLabel = LabelMaker(
        font: .body_5_M,
        fontColor: .red600
    ).make()
    
    public var hasLeftImage: Bool
    
    public init(hasLeftImage: Bool = false) {
        self.hasLeftImage = hasLeftImage
        super.init(frame: .zero)
        
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    public override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearButtonRect = super.clearButtonRect(forBounds: bounds)
        clearButtonRect.origin.x -= 5
        return clearButtonRect
    }
    
    private func layout() {
        setCornerRadius(6)
        backgroundColor = .gray10
        font = .body_3_M
        clearButtonMode = .whileEditing
        
        if hasLeftImage {
            leftViewMode = .always
        }
        
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func bind() {
        self.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    owner.layer.borderWidth = 1
                    if owner.isError.value { return }
                    owner.layer.borderColor = UIColor.violet500.cgColor
                }
            ).disposed(by: bag)
        
        self.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    if owner.isError.value { return }
                    self.layer.borderWidth = 0
                }
            ).disposed(by: bag)
        
        isError.asDriver()
            .drive(
                with: self,
                onNext: { owner, isError in
                    owner.errorLabel.isHidden = !isError
                    
                    if isError {
                        owner.layer.borderColor = UIColor.red500.cgColor
                    } else {
                        owner.layer.borderColor = UIColor.violet500.cgColor
                    }
                }
            ).disposed(by: bag)
    }
    
    public func setPlaceholder(
        text: String,
        alignment: NSTextAlignment = .left,
        font: UIFont,
        color: UIColor = .gray50
    ) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        self.textAlignment = alignment
        self.adjustsFontSizeToFitWidth = true
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraph,
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: font
            ]
        )
    }
    
    public func setErrorMessage(message: String) {
        errorLabel.text = message
        message == "" ? isError.accept(false) : isError.accept(true)
    }
}
