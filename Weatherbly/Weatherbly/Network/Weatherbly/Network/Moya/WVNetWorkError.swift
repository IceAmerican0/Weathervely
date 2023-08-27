//
//  WVNetWorkError.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/27.
//

import Foundation

/// NetworkError는 badReauestError 에서 code와 message 받아서 처리
/// 나머지 커스텀 error는 clientError로 커스텀 한다
public enum WVNetworkError: Error {
    case badRequestError(_ msg: String)
    case clientError(_ msg: String)
    case noInternetError
    case decodeError
    case encodeError
}

extension WVNetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .badRequestError(let msg):
            return msg
        case .clientError(let msg):
            return msg
        case .noInternetError:
            return "인터넷에 연결되어 있지 않습니다"
        case .decodeError:
            return "서버가 불안정 합니다"
        case .encodeError:
            return "WBNetworkError : Encoding Error"
        }
    }
}


