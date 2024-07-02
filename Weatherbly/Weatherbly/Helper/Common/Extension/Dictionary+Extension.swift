//
//  Dictionary+Extension.swift
//  Weatherbly
//
//  Created by Khai on 7/2/24.
//

import Foundation

extension Dictionary {
    public func prettyPrinted() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let jsonString = String(data: data, encoding: .utf8) {
                return jsonString
            }
            return "\(self)"
        } catch {
            return "Failed to convert dictionary to JSON"
        }
    }
}
