//
//  RegionProvider.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift

public final class RegionProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> Single<Response> {
        rx
            .request(token)
            .filterSuccessfulStatusCodes()
    }
    
    func mapTo<D: Decodable>(_ type: D.Type) -> Observable<D> {
        flatMap {
            do {
                let errorResponse = try $0.map(WBErrorResponse.self)
                let dataHeader = errorResponse.dataHeader
                
                switch dataHeader.result {
                case .success:
                    let decodedValue = try $0.map(type)
                    return .just(decodedValue)
                case .failure:
                    return .error(RemoteError.taskFail(dataHeader))
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
