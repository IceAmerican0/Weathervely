//
//  RegionProvider.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift
import RxMoya
import Foundation

public final class RegionProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> Single<Response> {
        rx
            .request(token)
//            .filterSuccessfulStatusCodes()
    }
    
}
