//
//  RegionQueryMapper.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/20.
//

import Foundation

public struct RegionQueryMapper {
    private let query: String
    
    public init(query: String) {
        self.query = query
    }
    
    public func toSearchRegionRequest() -> SearchRegionRequest {
        return SearchRegionRequest(query: query)
    }
}
