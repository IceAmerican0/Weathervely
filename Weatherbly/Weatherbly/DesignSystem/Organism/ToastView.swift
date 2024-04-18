//
//  ToastView.swift
//  Weatherbly
//
//  Created by Khai on 1/23/24.
//

import UIKit
import Then

public class ToastView: UIView {
    private let label = LabelMaker(
        font: .body_3_M,
        fontColor: .white,
        alignment: .center
    ).make().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.lineBreakMode = .byWordWrapping
        $0.backgroundColor = .clear
    }
    
    public init(
        frame: CGRect = .zero,
        text: String,
        completionHandler: (() -> Void)? = nil
    ) {
        label.text = text
        super.init(frame: frame)
        layout()
        dismiss()
        completionHandler?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black90
        isUserInteractionEnabled = true
        clipsToBounds = true
        setCornerRadius(8)
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    public func dismiss() {
        UIView.animate(
            withDuration: 0.5,
            delay: 2,
            options: .curveEaseInOut,
            animations: {
                 self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
}
