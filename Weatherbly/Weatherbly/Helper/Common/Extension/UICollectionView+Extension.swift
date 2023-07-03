//
//  UICollectionView+Extension.swift
//  Weatherbly
//
//  Created by 60156056 on 2023/07/03.
//

import UIKit

public extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell")
        }
        return cell
    }
    
    func register<T: UICollectionViewCell>(withType type: T.Type) {
        register(type.self, forCellWithReuseIdentifier: type.identifier)
    }
}
