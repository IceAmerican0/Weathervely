//
//  ItemHeaderFlowLayout.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/30/24.
//

import Foundation
import UIKit

class ItemHeaderFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: UICollectionViewDelegateFlowLayout?
    override func prepare() {
           super.prepare()
        
            self.scrollDirection = .horizontal
           guard let collectionView = collectionView else { return }
           
           let availableWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
           let itemCount = collectionView.numberOfItems(inSection: 0)
           
           var xOffset: CGFloat = 0
           var yOffset: CGFloat = 0
           var rowHeight: CGFloat = 0
           
           var attributes: [UICollectionViewLayoutAttributes] = []
           
           for item in 0..<itemCount {
               let indexPath = IndexPath(item: item, section: 0)
               let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
               
               let itemSize = delegate?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? CGSize(width: 50, height: 50)
               
               if xOffset + itemSize.width > availableWidth {
                   xOffset = 0
                   yOffset += rowHeight
                   rowHeight = 0
               }
               
               attribute.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
               attributes.append(attribute)
               
               xOffset += itemSize.width + minimumInteritemSpacing
               rowHeight = max(rowHeight, itemSize.height + minimumLineSpacing)
           }
           
           self.itemSize = CGSize(width: availableWidth / 2 - minimumInteritemSpacing, height: rowHeight)
           self.invalidateLayout()
       }
}

