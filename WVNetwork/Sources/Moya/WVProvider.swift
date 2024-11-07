//
//  WVProvider.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/10/06.
//

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
            debugPrint(
                """
                🚀🚀🚀 Network Request 🚀🚀🚀
                Path: \(request.path)
                Parameters: \(parameters.prettyPrinted())
                """
            )
        } else {
            debugPrint(
                """
                🚀🚀🚀 Network Request 🚀🚀🚀
                RequestPath: \(request.path)
                """
            )
        }
    }
}
