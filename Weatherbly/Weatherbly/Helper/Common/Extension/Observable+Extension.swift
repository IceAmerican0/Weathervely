//
//  Observable+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/20.
//

import RxSwift

public extension Observable {
    func mapRemoteError(_ handler: @escaping(RemoteError) -> Error) -> Observable<Element> {
        `catch` { error -> Observable<Element> in
            guard let error = error as? RemoteError else { throw error }
            throw handler(error)
        }
        .asObservable()
    }
}
