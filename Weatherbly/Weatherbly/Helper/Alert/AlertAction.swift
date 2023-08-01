//
//  AlertAction.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit

final class AlertAction {
    private var windowLevel: UIWindow.Level
    private var alertWindow: AlertWindow?
    
    init(windowLevel: UIWindow.Level) {
        self.windowLevel = windowLevel
    }
    
    func present(contents: AlertViewState) {
        alertWindow = AlertWindow(level: windowLevel)
        alertWindow?.accessibilityViewIsModal = true
        
        let alert = AlertView(state: contents)
        alertWindow?.present(view: alert)
    }
    
    func dismiss(completion: AlertActionHandler?) {
        self.alertWindow?.dismiss()
        self.alertWindow = nil
        completion?()
    }
}
