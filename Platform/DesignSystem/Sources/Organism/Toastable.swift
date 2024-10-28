//
//  Toastable.swift
//  DesignSystem
//
//  Created by Khai on 10/28/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit

public protocol Toastable {
    func presentToast(content: String)
}

public extension Toastable where Self: UIViewController {
    func presentToast(content: String) {
        let toast = ToastView(text: state.title)
        view.addSubview(toast)
        
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: superView.leadingAnchor, constant: 15),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor, constant: -15),
            toast.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            toast.heightAnchor.constraint(lessThanOrEqualToConstant: 58)
        ])
    }
}
