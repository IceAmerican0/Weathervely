//
//  ThemeTitleHeaderView.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/21/24.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout
import Then
import RxCocoa


public class StyleTagHeaderView: UICollectionReusableView {
    var bag = DisposeBag()
    
    public let tags = ["비즈니스 캐주얼", "캐주얼", "시크", "걸리시", "레트로","로맨틱", "스트릿"]
    
    private let container = UIView()
    
    var testView = UIView().then {
        $0.backgroundColor = .red
    }
    
    lazy var tagCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 12
        $0.estimatedItemSize = CGSize(width: 100, height: 30)
    }
    
    public lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: StyleTagCell.self)
        $0.dataSource = self
        $0.delegate = self
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.flex.layout()
    }
    
    func layout() {
        self.flex.addItem(tagCollectionView).width(100%).height(56).alignContent(.center).backgroundColor(.violet200).direction(.row).justifyContent(.center)
    }
}

extension StyleTagHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: StyleTagCell.self, for: indexPath)
        cell.tagLabel.text = self.tags[indexPath.row]

        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    func setLayout() -> UICollectionViewCompositionalLayout {
        
        UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .absolute(29)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100),
                heightDimension: .absolute(29)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: itemSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 0)

            section.interGroupSpacing = 12
            return section
        }
    }
}


