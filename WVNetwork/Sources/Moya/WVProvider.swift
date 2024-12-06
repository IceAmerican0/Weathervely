//
//  WVProvider.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/10/06.
//

import UIUtil
import RxSwift
import Moya

public final class WVProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> Single<Response> {
        checkRequest(token)
        
        return rx.request(token)
                .mapNetworkError()
//            .filterSuccessfulStatusCodes()
    }
    
    func checkRequest(_ request: T) {
        if case let .requestParameters(parameters, _) = request.task {
            debuggerPrint(
                """
                🚀🚀🚀 Network Request 🚀🚀🚀
                Path: \(request.path)
                Parameters: \(parameters.prettyPrinted())
                """
            )
        } else {
            debuggerPrint(
                """
                🚀🚀🚀 Network Request 🚀🚀🚀
                RequestPath: \(request.path)
                """
            )
        }
    }
}
