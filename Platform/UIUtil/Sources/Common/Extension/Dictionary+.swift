//
//  Dictionary+.swift
//  Weatherbly
//
//  Created by Khai on 7/2/24.
//

import Foundation

public extension Dictionary {
    func prettyPrinted() -> String {
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

extension Dictionary where Value: Any {
    /// 파라미터 빈값일시 포함시키지 않음
    public func removeEmptyParameters() -> [Key: Any] {
        self.compactMapValues { value in
            if let string = value as? String {
                return string.isEmpty ? nil : value
            }
            
            if let array = value as? [Any] {
                return array.isEmpty ? nil : array
            }
            
            if let dict = value as? [AnyHashable: Any] {
                return dict.isEmpty ? nil : dict
            }
            
            return value
        }
    }
}
