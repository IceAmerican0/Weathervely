//
//  RegionProvider.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift
import RxMoya

public final class RegionProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> Single<Response> {
        rx
            .request(token)
            .filterSuccessfulStatusCodes()
    }
    
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapTo<D: Decodable>(_ type: D.Type) -> Observable<D> {
        flatMap {
            do {
                let errorResponse = try $0.map(KakaoErrorResponse.self)
                if let dataHeader = errorResponse.code {
                    switch dataHeader {
                    case 200..<300:
                        let decodedValue = try $0.map(type)
                        return .just(decodedValue)
                    default:
                        return .error(RemoteError.taskFail(errorResponse))
                    }
                }
            } catch(let error) {
                if let error = error as? MoyaError {
                    return .error(RemoteError.networkError(error))
                }
            }
            
            return .error(RemoteError.unknownError)
        }
        .asObservable()
    }
}
