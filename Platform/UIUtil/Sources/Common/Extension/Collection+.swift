//
//  Collection+.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/26/24.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
