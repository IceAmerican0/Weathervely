//
//  RemoteError.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Foundation
import Moya

public enum RemoteError: Error {
    case networkError(MoyaError)
    case taskFail(KakaoErrorResponse)
    case unknownError
}
