//
//  WBErrorResponse.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Foundation

public struct WBErrorResponse: Decodable {
    public let dataHeader: WBErrorHeader
}

public struct WBErrorHeader: Decodable {
    public enum HeaderResult: String, Decodable {
        case success = "SUCCESS"
        case failure = "FAIL"
    }
}
