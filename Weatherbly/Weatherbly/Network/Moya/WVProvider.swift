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
//            .filterSuccessfulStatusCodes()
//            .mapNetworkError()
    }
    
    func checkRequest(_ request: T) {
        if case let .requestParameters(parameters, _) = request.task {
            debugPrint("Request: \(parameters.prettyPrinted())")
        }
    }
}
