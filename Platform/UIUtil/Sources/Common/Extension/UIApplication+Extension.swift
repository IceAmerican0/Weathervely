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
        Task { @MainActor in
            try await Task.sleep(for: .seconds(0.3))
            exit(0)
        }
    }
}
