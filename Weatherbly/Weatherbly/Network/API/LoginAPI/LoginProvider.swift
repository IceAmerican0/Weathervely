//
//  LoginProvider.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/24.
//

import Foundation
import Moya
import RxSwift


public final class LoginProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> Single<Response> {
        rx
            .request(token)
            .filterSuccessfulStatusCodes()
    }
    
}
