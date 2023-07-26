//
//  PrimitiveSequence+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import Moya
import RxSwift
import RxMoya
import Foundation

<<<<<<< HEAD:Weatherbly/Weatherbly/Network/API/Region/RegionProvider.swift
public final class RegionProvider<T: TargetType>: MoyaProvider<T> {
    func request(_ token: T) -> Single<Response> {
        rx
            .request(token)
//            .filterSuccessfulStatusCodes()
    }
    
=======
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapTo<D: Decodable>(_ type: D.Type) -> Observable<Result<D, Error>> {
        flatMap { response in
            do {
                
//                let errorResponse = try $0.map(KakaoErrorResponse.self)
//                if let dataHeader = errorResponse.code {
//                    switch dataHeader {
//                    case 200..<300:
//                        let decodedValue = try $0.map(type)
//                        return .just(decodedValue)
//                    default:
//                        return .error(RemoteError.taskFail(errorResponse))
//                    }
//                }
                
                if !(200..<300 ~= response.statusCode) {
                    return .error(RemoteError.unknownError)
                } else {
                    guard let dictionary = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any] else { return .just(.failure(RemoteError.unknownError))}
                    print(dictionary)
                    return .just(.success(try response.map(D.self)))
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
>>>>>>> feature/동네설정뷰:Weatherbly/Weatherbly/Network/Weatherbly/Network/Moya/PrimitiveSequence+Extension.swift
}
