//
//  AlertManager.swift
//  WVAlert
//
//  Created by Khai on 10/28/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit

public final class AlertManager {
    public static let shared = AlertManager(windowLevel: .statusBar)
    
    private var windowLevel: UIWindow.Level
    private(set) var alertWindow: AlertWindow?
    
    init(windowLevel: UIWindow.Level) {
        self.windowLevel = windowLevel
    }
    
    public func present(state: AlertViewState) {
        if alertWindow != nil {
            dismiss()
        }
        
        alertWindow = AlertWindow(level: windowLevel)
        alertWindow?.accessibilityViewIsModal = true
        
        let alert = AlertView(state: state)
        alertWindow?.present(view: alert)
    }
    
    public func dismiss(completion: AlertActionHandler? = nil) {
        alertWindow?.dismiss()
        alertWindow = nil
        completion?()
    }
}
