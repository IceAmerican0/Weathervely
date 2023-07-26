//
//  PrimitiveSequence+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/24.
//

import Foundation
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapTo<D: Decodable>(_ type: D.Type) -> Observable<Result<D, Error>> {
        flatMap { response in
            do {
                if !(200..<300 ~= response.statusCode) {
                    return .error(RemoteError.unknownError)
                } else {
                    guard let dictionary = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any] else {

                        return .just(.failure(RemoteError.unknownError))
                    }                    
//                    let dictionary = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any]
                    print("PrimitiveSequence :", dictionary)
                    return .just(.success(try response.map(D.self)))
                }
            } catch(let error) {
                if let error = error as? MoyaError {
                    print("PrimitiveSequence Error: ", error.localizedDescription)
                    return .error(RemoteError.networkError(error))
                }
            }
            
            return .error(RemoteError.unknownError)
        }
        .asObservable()
    }
}
