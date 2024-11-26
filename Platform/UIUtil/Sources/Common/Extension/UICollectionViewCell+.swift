//
//  UICollectionViewCell+.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/03.
//

import UIKit

public extension UICollectionViewCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}
