//
//  File.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/24.
//

import Foundation
import RxSwift

protocol LoginDataSourceProtocol {
    func login(_ nickname: String) -> Observable<Result<LoginEntity, WBNetworkError>>
}

class LoginDataSource: LoginDataSourceProtocol {
    
    private let provider = LoginProvider<LoginTarget>()
    
    func login(_ nickname: String) -> Observable<Result<LoginEntity, WBNetworkError>> {
        provider
            .request(.login(nickname: nickname))
            .mapTo(LoginEntity.self)
    }
}
