//
//  HomeBannerLayout.swift
//  Weatherbly
//
//  Created by Khai on 5/17/24.
//

import UIKit

public final class HomeBannerLayout: UICollectionViewLayout {
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    fileprivate let itemSpacing: CGFloat = 19
    fileprivate let firstItemHeight: CGFloat = 158
    fileprivate let otherItemHeight: CGFloat = 236
    fileprivate let numberOfColumns = 2
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView else { return 0.0 }
        let inset = collectionView.contentInset
        return collectionView.bounds.width - (inset.left + inset.right)
    }
    fileprivate var contentHeight: CGFloat = 0.0
    
    public override var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }
    
    public override func prepare() {
        super.prepare()
        guard cache.isEmpty, let collectionView else { return }
        
        for section in 0..<collectionView.numberOfSections {
            let indexPath = IndexPath(item: 0, section: section)
            
            if section == 0 {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 164)
                cache.append(attributes)
            } else {
                // 헤더 부분
                let attributes = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    with: indexPath
                )
                attributes.frame = CGRect(x: 0, y: 178, width: Constants.screenWidth, height: 56)
                cache.append(attributes)
                
                // 셀 부분
                let columnWidth = (contentWidth - itemSpacing - 40) / CGFloat(numberOfColumns)
                
                var column = 0
                var xOffset: [CGFloat] = [20]
                var yOffset = [CGFloat](repeating: 234, count: numberOfColumns)
                
                // 각 열의 x좌표
                for column in 1..<numberOfColumns {
                    let column = CGFloat(column)
                    let offset = (column * columnWidth) + (column * 19) + 20
                    xOffset.append(offset)
                }
                
                // 셀 크기에 따른 좌표 구하기
                for item in 0..<collectionView.numberOfItems(inSection: 1) {
                    let indexPath = IndexPath(item: item, section: 1)
                    
                    let height = (item == 0) ? firstItemHeight : otherItemHeight
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    let insetFrame = frame.insetBy(dx: 0, dy: 0)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    
                    contentHeight = max(contentHeight, frame.maxY + itemSpacing)
                    yOffset[column] = yOffset[column] + height + itemSpacing
                    column = (column >= (numberOfColumns - 1)) ? 0 : (column + 1)
                }
            }
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = cache.filter { $0.frame.intersects(rect) }
        
        if let stickyAttributes = getStickyAttributes(
            at: IndexPath(item: 0, section: 1)
        ) {
            layoutAttributes.insert(stickyAttributes, at: 0)
        }
        
        return layoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section == 1 else { return nil }
        return cache[indexPath.item]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache.first { $0.indexPath == indexPath && $0.representedElementKind == elementKind }
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    public override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        cache.removeAll()
        contentHeight = 0
    }
}
