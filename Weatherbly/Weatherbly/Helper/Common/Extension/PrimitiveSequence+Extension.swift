//
//  PrimitiveSequence+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/24.
//

import Foundation
import RxSwift
import Moya

/*
 /// Exception 시 response
 {
     "domain": "generic",
     "apiMessage": {
         "statusCode": 404,
         "message": "Cannot GET /forecast/getVillageForeca",
         "error": "Not Found"
     },
     "status": 404,
     "id": "JnIxCbAeSfl4i4HB",
     "timestamp": "2023-07-27T06:17:35.431Z"
 }
 */

/// PrimitiveSequence = Observable 시퀀스타입
/// Single은 여러개의 항목 시리지를 배출하는 대신 항상 단일 항목 혹은 오류를 배출한다고 보장되는 Observable
/// 즉 PrimitiveSequence 에서 Trait을 SingleTrait으로 지정하는 것은 오류또는 단일항목을 반드시 배출하도록 보장한다.

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func mapTo<D: Decodable>(_ type: D.Type) -> Observable<Result<D, WBNetworkError>> {
        flatMap { response in
            do {
                
                if (200..<300 ~= response.statusCode) { // status : 200
                    guard try JSONSerialization.jsonObject(with: response.data, options: []) is [String:Any] else {
                        return .just(.failure(.decodeError))
                    }
                    
//                    debugPrint(
//                        """
//                        ==============================
//                        Request : \(type)
//                        Response : \(String(decoding: response.data, as: UTF8.self))
//                        """
//                    )
                    return .just(.success(try response.map(D.self)))
                } else {
                    // status : !(200 ~ 300)
                    guard let dictionary = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any] else {
                        return .just(.failure(.decodeError))
                    }
                    
                    if let status = dictionary["status"] as? Int , let apiMessage = dictionary["apiMessage"] as? [String:Any] {
                        let errDescription = apiMessage["message"] as? String
//                        debugPrint(
//                            """
//                            ==============================
//                            Request : \(type)
//                            Response : \(dictionary)
//                            """
//                        )
                        return .just(.failure(.badRequestError(errDescription!)))
                    }
                }
            } catch(let error) {
//                debugPrint(error)
//                debugPrint(String(decoding: response.data, as: UTF8.self))
                return .just(.failure(.decodeError))
            }
            
            return .error(RemoteError.unknownError)
        }
        .asObservable()
    }
}
