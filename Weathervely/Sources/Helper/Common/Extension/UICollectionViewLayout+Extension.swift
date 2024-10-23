//
//  UICollectionViewLayout+Extension.swift
//  Weathervely
//
//  Created by Khai on 10/21/24.
//

import UIKit

extension UICollectionViewLayout {
    /// sticky header 생성
    public func getStickyAttributes(at indexPath: IndexPath?) -> UICollectionViewLayoutAttributes? {
        // header layout attribute 받아오기
        guard let collectionView,
              let indexPath,
              let stickyAttributes = layoutAttributesForSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                at: indexPath
              )?.copy() as? UICollectionViewLayoutAttributes
              else {
            return nil
        }
        
        let contentOffsetY = collectionView.contentOffset.y
        var frame = stickyAttributes.frame
        
        // collectionView Offset Y값을 header의 Y값과 비교하여 초과시 상단 고정 노출
        if contentOffsetY > frame.origin.y {
            frame.origin.y = contentOffsetY
            stickyAttributes.frame = frame
            stickyAttributes.zIndex = 1
            return stickyAttributes
        }
        return nil
    }
    
    /// 글자 길이에 따른 유동적인 셀 레이아웃(가로 스크롤)
    public func setFlexibleLayout(
        itemSpacing: CGFloat = 10,
        groupSpacing: CGFloat = 10
    ) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(70),
                heightDimension: .estimated(29)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let layoutGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: itemSize,
                subitems: [item]
            )
            layoutGroup.interItemSpacing = .fixed(itemSpacing)
            
            let section = NSCollectionLayoutSection(group: layoutGroup)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0, leading: 0, bottom: 0, trailing: 0
            )
            section.interGroupSpacing = groupSpacing
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
}
