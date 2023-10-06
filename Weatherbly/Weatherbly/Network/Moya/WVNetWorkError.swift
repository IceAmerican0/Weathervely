//
//  WVNetWorkError.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/27.
//

import Foundation
import Moya

/// NetworkError는 badReauestError 에서 code와 message 받아서 처리
/// 나머지 커스텀 error는 clientError로 커스텀 한다
public enum WVNetworkError: Error {
    case badRequestError(_ msg: String)
    case clientError(_ msg: String)
    case timeoutError
    case decodeError
    case encodeError
    case networkError(MoyaError)
    case unknownError
}

extension WVNetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .badRequestError(let msg):
            return msg
        case .clientError(let msg):
            return msg
        case .timeoutError:
            return "요청시간이 초과되었습니다"
        case .decodeError:
            return "서버가 불안정 합니다"
        case .encodeError:
            return "WBNetworkError : Encoding Error"
        case .networkError(let msg):
            return "\(msg.localizedDescription)"
        case .unknownError:
            return "unknownError"
        }
    }
}


