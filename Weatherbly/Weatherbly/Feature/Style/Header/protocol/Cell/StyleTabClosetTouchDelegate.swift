//
//  StyleTabClosetTouchDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/14/24.
//

import Foundation
import UIKit

protocol StyleTabClosetTouchDelegate: AnyObject {
    func innerCollectionViewDidScroll(_ innerCollectionView: UICollectionView, contentOffset: CGPoint)
    func innerCollectionViewCellDidTap(_ selectedInfo: NewClosetInfo?)
}
