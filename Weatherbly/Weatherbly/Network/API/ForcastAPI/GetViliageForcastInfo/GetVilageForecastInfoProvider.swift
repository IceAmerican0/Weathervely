//
//  GetClosetProvider.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/26.
//

import Foundation
import RxSwift
import Moya

class GetVilageForecastInfoProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> Single<Response> {
        rx
            .request(token)
            .filterSuccessfulStatusCodes()
    }
}
