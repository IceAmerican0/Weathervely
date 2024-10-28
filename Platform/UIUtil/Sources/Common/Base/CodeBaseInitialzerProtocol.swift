//
//  CodeBaseInitializer.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/09.
//

import Foundation

protocol CodeBaseInitializerProtocol {
    func codeBaseInitializer()
    func layout()
    func bind()
}

extension CodeBaseInitializerProtocol {
    func codeBaseInitializer() {
        layout()
        bind()
    }

    func layout() { }

    func bind() { }
}
