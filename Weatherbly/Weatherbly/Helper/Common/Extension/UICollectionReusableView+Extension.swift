//
//  UICollectionReusableView+Extension.swift
//  Weatherbly
//
//  Created by Khai on 1/5/24.
//

import UIKit

extension UICollectionReusableView: CollectionReusableView {}

public protocol CollectionReusableView {
    static var identifier: String { get }
}

public extension CollectionReusableView where Self: UICollectionReusableView {
    static var identifier: String {
        String(describing: Self.self)
    }
}
