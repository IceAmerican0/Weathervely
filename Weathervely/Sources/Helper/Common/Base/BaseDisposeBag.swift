//
//  BaseDisposeBag.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import RxSwift

protocol BaseDisposebag {
    var bag: DisposeBag { get }
}
