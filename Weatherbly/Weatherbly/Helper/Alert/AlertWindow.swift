//
//  AlertWindow.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/01.
//

import UIKit

protocol AlertPresentableWindow {
    func present(view: UIView)
    func dismiss()
}

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

public final class AlertWindow:
    Window,
    AlertPresentableWindow
{
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

