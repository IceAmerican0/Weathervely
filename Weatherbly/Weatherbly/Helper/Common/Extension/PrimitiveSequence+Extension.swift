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
    func mapTo<D: Decodable>(_ type: D.Type) -> Observable<D> {
        flatMap { response in
            do {
                if (200..<300 ~= response.statusCode) { // status : 200
                    guard try JSONSerialization.jsonObject(with: response.data, options: []) is [String:Any] else {
                        return .error(WVNetworkError.decodeError)
                    }
                    
                    #if DEBUG
                    print(
                        """
                        Request : \(type)
                        Response : \(String(decoding: response.data, as: UTF8.self))
                        """
                    )
                    #endif
                    
                    return .just(try response.map(type))
                } else { // status : !(200 ~ 300)
                    guard let dictionary = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any] else {
                        return .error(WVNetworkError.decodeError)
                    }
                    
                    if let apiMessage = dictionary["apiMessage"] as? [String:Any] {
                        let errMessage = apiMessage["message"] as? String ?? ""
                        let errDetail = apiMessage["detail"] as? String ?? ""
                        
                        #if DEBUG
                        print(
                            """
                            Request : \(type)
                            Response : \(dictionary)
                            """
                        )
                        #endif
                        
                        return .error(WVNetworkError.badRequestError(errDetail.isEmpty ? errMessage : errDetail))
                    }
                }
            } catch(let error) {
                #if DEBUG
                print(String(decoding: response.data, as: UTF8.self))
                #endif
                
                if let error = error as? MoyaError {
                    return .error(WVNetworkError.networkError(error))
                }
            }
            
            return .error(WVNetworkError.unknownError)
        }
        .asObservable()
    }
    
    func mapNetworkError() -> Single<Response> {
        `catch` { error in
            guard let error = error as? MoyaError else {
                throw WVNetworkError.unknownError
            }
            throw WVNetworkError.networkError(error)
        }
    }
}
