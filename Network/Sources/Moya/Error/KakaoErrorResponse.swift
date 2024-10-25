//
//  KakaoErrorResponse.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/17.
//

import Foundation

public struct KakaoErrorResponse: Decodable {
    public let code: Int?
    public let msg: String?
}
