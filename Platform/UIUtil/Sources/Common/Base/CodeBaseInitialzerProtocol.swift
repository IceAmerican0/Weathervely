//
//  CodeBaseInitializer.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/09.
//

import Foundation

public protocol CodeBaseInitializerProtocol {
    func codeBaseInitializer()
    func layout()
    func bind()
}

extension CodeBaseInitializerProtocol {
    public func codeBaseInitializer() {
        layout()
        bind()
    }

    public func layout() { }

    public func bind() { }
}
