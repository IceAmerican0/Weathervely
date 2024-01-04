//
//  UICollectionView+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/03.
//

import UIKit

public extension UICollectionView {
    /// 휴먼 에러 방지용 dequeue
    func dequeueCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell")
        }
        return cell
    }
    
    /// 휴먼 에러 방지용 cell register
    func register<T: UICollectionViewCell>(withType type: T.Type) {
        register(type.self, forCellWithReuseIdentifier: type.identifier)
    }
}

public extension FSPagerView {
    func dequeueCell<T: FSPagerViewCell>(withType type: T.Type, for indexPath: Int) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, at: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell")
        }
        return cell
    }
    
    func register<T: FSPagerViewCell>(withType type: T.Type) {
        register(type.self, forCellWithReuseIdentifier: type.identifier)
    }
}
