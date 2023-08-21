//
//  WBNetWorkError.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/27.
//

import Foundation

/// NetworkError는 badReauestError 에서 code와 message 받아서 처리
/// 나머지 커스텀 error는 clientError로 커스텀 한다
public enum WBNetworkError: Error {
    case badRequestError(_ msg: String)
    case clientError(_ msg: String)
    case decodeError
    case encodeError
}

extension WBNetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .badRequestError(let msg):
            return msg
        case .clientError(let msg):
            return msg
        case .decodeError:
            return "서버가 불안정 합니다"
        case .encodeError:
            return "WBNetworkError : Encoding Error"
        }
    }
}


