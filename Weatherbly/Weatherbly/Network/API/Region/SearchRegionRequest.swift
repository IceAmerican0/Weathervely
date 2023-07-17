//
//  SearchRegionRequest.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/14.
//

import Foundation

public struct SearchRegionRequest: Encodable {
    public let query: String
    
    public init(query: String) {
        self.query = query
    }
}
