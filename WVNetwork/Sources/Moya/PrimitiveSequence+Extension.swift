//
//  PrimitiveSequence+.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/24.
//

import UIUtil
import Foundation
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func mapTo<D: Decodable>(_ type: D.Type) -> Observable<D> {
        flatMap { response in
            do {
                guard let object = try? JSONSerialization.jsonObject(
                    with: response.data,
                    options: []
                ) as? [String:Any]
                else {
                    return .error(WVNetworkError.decodeError)
                }
                
                debuggerPrint(
                    """
                    ✅✅✅ Network Success ✅✅✅
                    ResponseType : \(type)
                    Response : \(object.prettyPrinted())
                    """
                )
                
                // status : 200
                if (200..<300 ~= response.statusCode) {
                    return .just(try response.map(type))
                }
                
                // status : !(200 ~ 300)
                if let apiMessage = object["apiMessage"] as? [String: Any],
                   let errMessage = apiMessage["message"] as? String {
                    
                    let errDetail = apiMessage["detail"] as? String
                    
                    return .error(WVNetworkError.badRequestError(
                        (errDetail == nil || errDetail == "" ? errMessage : errDetail) ?? "unknownError")
                    )
                }
            } catch(let error) {
                var responseString = ""
                
                if let object = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any] {
                    responseString = object.prettyPrinted()
                } else {
                    responseString = String(decoding: response.data, as: UTF8.self)
                }
                
                debuggerPrint(
                    """
                    🔥🔥🔥 Network Failed 🔥🔥🔥
                    ResponseType : \(type)
                    Response : \(responseString)
                    Error : \(error)
                    """
                )
                
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
