//
//  AlertManager.swift
//  WVAlert
//
//  Created by Khai on 10/28/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit

public final class AlertManager {
    public static let shared = AlertManager()
    
    private var window: UIWindow?
    
    public init() {
        getWindow()
    }
    
    public func present(state: AlertViewState) {
        Task { @MainActor in
            let alert = AlertView(state: state)
            
            UIAccessibility.post(
                notification: .layoutChanged,
                argument: alert
            )
            window?.addSubview(alert)
        }
    }
    
    public func dismiss() {
        Task { @MainActor in
            guard let alertView = self.window?.subviews.last else { return }
            alertView.removeFromSuperview()
        }
    }
    
    private func getWindow() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        window.accessibilityViewIsModal = true
        self.window = window
    }
}
