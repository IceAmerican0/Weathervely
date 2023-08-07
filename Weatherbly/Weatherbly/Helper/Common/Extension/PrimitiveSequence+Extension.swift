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

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapTo<D: Decodable>(_ type: D.Type) -> Observable<Result<D, WBNetworkError>> {
        flatMap { response in
            do {
                
                if (200..<300 ~= response.statusCode) { // status : 200
                    guard let dictionary = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any] else {
                        return .just(.failure(.decodeError))
                    }
//                    print("PrimitiveSequence : ", dictionary)
                    return .just(.success(try response.map(D.self)))
                } else {
                    // status : !(200 ~ 300)
                    guard let dictionary = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any] else {
                        return .just(.failure(.decodeError))
                    }
                    
                    if let status = dictionary["status"] as? Int , let apiMessage = dictionary["apiMessage"] as? [String:Any] {
                        let errDescription = apiMessage["message"] as? String
                        print(
                            """
                            =================
                            Status : \(status)
                            message : \(errDescription!)
                            """
                        )
                        return .just(.failure(.badRequestError(errDescription!)))
                    }
                }
            } catch(let error) {
                print(error)
                print(String(decoding: response.data, as: UTF8.self))
                return .just(.failure(.decodeError))
            }
            
            return .error(RemoteError.unknownError)
        }
        .asObservable()
    }
}
