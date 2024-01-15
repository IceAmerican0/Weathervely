//
//  UnderlineTitleSegmentView.swift
//  Weatherbly
//
//  Created by Khai on 1/15/24.
//

import UIKit
import FlexLayout
import PinLayout

public struct UnderlineTitleSegmentItem {
    let title: String
    var selected = false
    var pageIndex: Int
}

public protocol UnderlineTitleSegmentDelegate: AnyObject {
    func selectedItem(item: UnderlineTitleSegmentItem)
}

final class UnderlineTitleSegmentView: UIView {
    weak var delegate: UnderlineTitleSegmentDelegate?
    
    private let container = UIView()
    private let underline = UIView().then {
        $0.backgroundColor = .gray600
        $0.setCornerRadius(1)
    }
    
    private lazy var segmentView = UICollectionView(
        frame: .zero,
        collectionViewLayout: setCompositionalLayout()
    ).then { [weak self] in
        $0.backgroundColor = .clear
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.bounces = false
        $0.register(withType: UnderlineTitleSegmentCell.self)
    }
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func layout() {
        addSubviews(container)
        container.flex.define {
            $0.addItem(segmentView).marginHorizontal(0).height(48)
        }
    }
    
    private func setCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(10),
            heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = .zero
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }
}
