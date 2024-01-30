//
//  UICollectionView+Extension.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/03.
//

import UIKit

public extension UICollectionView {
    enum Elements: String {
        case sectionHeader = "UICollectionElementKindSectionHeader"
        case sectionFooter = "UICollectionElementKindSectionFooter"
    }
    
    // MARK: Dequeue
    
    /// 휴먼 에러 방지용 dequeueCell
    func dequeueCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable cell")
        }
        return cell
    }
    
    /// 휴먼 에러 방지용 dequeue ReusableHeader
    func dequeueReusableHeaderView<T: UICollectionReusableView>(withType type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableView(withType: type, kind: .sectionHeader, for: indexPath)
    }
    
    /// 휴먼 에러 방지용 dequeue ReusableFooter
    func dequeueReusableFooterView<T: UICollectionReusableView>(withType type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableView(withType: type, kind: .sectionFooter, for: indexPath)
    }
    
    /// 휴먼 에러 방지용 dequeue ReusableView
    func dequeueReusableView<T: UICollectionReusableView>(withType type: T.Type, kind: Elements, for indexPath: IndexPath) -> T {
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue reusable view - \(kind.rawValue)")
        }
        return reusableView
    }
    
    // MARK: Register
    
    /// 휴먼 에러 방지용 cell register
    func register<T: UICollectionViewCell>(withType type: T.Type) {
        register(type.self, forCellWithReuseIdentifier: type.identifier)
    }
    
    /// 휴먼 에러 방지용 ReusableView Header register
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type) {
        registerReusableView(withType: type, kind: .sectionHeader)
    }
    
    /// 휴먼 에러 방지용 ReusableView Footer register
    func registerFooter<T: UICollectionReusableView>(withType type: T.Type) {
        registerReusableView(withType: type, kind: .sectionFooter)
    }
    
    /// 휴먼 에러 방지용 dequeue ReusableView
    func registerReusableView<T: UICollectionReusableView>(withType type: T.Type, kind: Elements) {
        register(type.self, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: type.identifier)
    }
}
