//
//  Encodable+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/27.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        let result = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
        
        if let result = result {
            return result
        } else {
            return [:]
        }
    }
    
    var asFilterDictionary: [String: [String]]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: [String]] }
    }
}
