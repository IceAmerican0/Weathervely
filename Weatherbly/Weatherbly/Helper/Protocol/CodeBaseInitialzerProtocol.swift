//
//  CodeBaseInitializer.swift
//  Weathervely
//
//  Created by 최수훈 on 2023/06/09.
//

import Foundation

// 코드로 작성하는 경우 아래의 주석을 활용한다.
// MARK: - UI Property
// MARK: - Control Property
// MARK: - Binding Property
// MARK: - Initialization
// MARK: - Attribute
// MARK: - Layout
// MARK: - Bind
// MARK: - Method

protocol CodeBaseInitializerProtocol {

    func codeBaseInitializer()

    func attribute()

    func layout()

    func bind()
}

extension CodeBaseInitializerProtocol {

    func codeBaseInitializer() {
        print("CodeProtocol", #function)
        attribute()
        layout()
        bind()
        print("CodeProtocol", #function)
        
    }

    func attribute() {
        print("CodeProtocol", #function)
    }

    func layout() {
        print("CodeProtocol", #function)
    }

    func bind() {
        print("CodeProtocol", #function)
    }

}
