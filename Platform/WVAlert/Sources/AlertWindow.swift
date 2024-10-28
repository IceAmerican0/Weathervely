//
//  AlertWindow.swift
//  WVAlert
//
//  Created by Khai on 10/28/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit

open class Window: UIWindow {
    init(level: UIWindow.Level) {
        super.init(frame: UIScreen.main.bounds)
        rootViewController = UIViewController()
        backgroundColor = .clear
        windowLevel = level
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class AlertWindow: Window {
    override public init(level: UIWindow.Level) {
        super.init(level: level)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func present(view: UIView) {
        isHidden = false
        addSubview(view)
    }
    
    public func dismiss() {
        isHidden = true
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
