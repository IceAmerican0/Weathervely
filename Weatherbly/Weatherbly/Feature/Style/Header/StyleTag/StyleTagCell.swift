//
//  StyleTagCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/9/24.
//

import UIKit
import FlexLayout
import PinLayout

final class StyleTagCell: UICollectionViewCell {
    
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center
    ).make(text: "#tag1")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        tagLabel.frame = bounds //  tagLabel이 부모 뷰를 완전히 덮도록 설정
        cellLayout()
    }
    
    private func attribute() {
        
        contentView.do {
            $0.layer.cornerRadius = 14
            $0.backgroundColor = UIColor.gray10
        }
        
        tagLabel.do {
            $0.numberOfLines = 1
        }
    }

    func cellLayout() {
        
        contentView.addSubview(tagLabel)
        tagLabel.pin.all()
    }
    
}

//func setBannerLayout() -> NSCollectionLayoutSection {
//    let cellSize = NSCollectionLayoutSize(
//        widthDimension: .fractionalWidth(1),
//        heightDimension: .absolute(80)
//    )
//    
//    let item = NSCollectionLayoutItem(layoutSize: cellSize)
//    let group = NSCollectionLayoutGroup.horizontal(
//        layoutSize: cellSize,
//        subitems: [item]
//    )
//    
//    let section = NSCollectionLayoutSection(group: group)
//    return section
//}
//
//// ClosetLayout
//func setClosetLayout() -> NSCollectionLayoutSection {
//    let cellSize = NSCollectionLayoutSize(
//        widthDimension: .absolute(120),
//        heightDimension: .absolute(572)
//    )
//    let item = NSCollectionLayoutItem(layoutSize: cellSize)
//    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 12, trailing: 0)
//    
//    /// Group = 한 화면에 들어가는 item을 묶은 단위
//    /// https://ios-development.tistory.com/945
//    let groupSize = NSCollectionLayoutSize(
//        widthDimension: .fractionalWidth(1),
//        heightDimension: .absolute(209)
//    )
//    
//    let group = NSCollectionLayoutGroup.vertical(
//        layoutSize: groupSize,
//        subitems: [item]
//    )
//    group.interItemSpacing = .fixed(16)
//    
//    // Header
//    let headerSize = NSCollectionLayoutSize(
//        widthDimension: .fractionalWidth(1),
//        heightDimension: .absolute(56)
//    )
//    
//    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//        layoutSize: headerSize,
//        elementKind: UICollectionView.elementKindSectionHeader,
//        alignment: .top
//    )
//    sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
//    sectionHeader.pinToVisibleBounds = true
//    
//    let section = NSCollectionLayoutSection(group: group)
//    section.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 10, bottom: 0, trailing: 0)
//    
//    section.interGroupSpacing = 12
//    section.boundarySupplementaryItems = [sectionHeader]
//    
//    return section
//}
