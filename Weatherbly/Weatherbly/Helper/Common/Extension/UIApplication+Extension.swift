//
//  UIApplication+Extension.swift
//  Weatherbly
//
//  Created by Khai on 7/22/24.
//

import UIKit

extension UIApplication {
    public func close() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exit(0)
        }
    }
}
