//
//  HorizonCollectionViewCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/18/24.
//

import UIKit
import PinLayout
import RxDataSources
import RxCocoa
import RxSwift

final public class HorizonCollectionViewCell: UICollectionViewCell {
    
    private var bag = DisposeBag()
    private var bindClosets = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    
    private lazy var collectionView =  UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: StyleCell.self)
    }
    lazy var dataSource = self.horizonCollectionViewDataSource()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
     
    private func layout() {
        contentView.pin.all()
        contentView.addSubview(collectionView)
        collectionView.pin.all().left(20)
    }
    
    private func binding() {
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        bindClosets
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    
    func configure(_ closets: [NewClosetInfo]?) {
        guard let closets = closets else { return }
        let models: [StyleTabItem] = closets.map { StyleTabItem.cloets($0) }
        bindClosets.accept([StyleTabSectionModel.closets(item: models)])
        
    }
}

extension HorizonCollectionViewCell: UICollectionViewDelegate {
    
    func horizonCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> {
        RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> (configureCell:  { [ weak self] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .cloets(let styleInfo):
                return collectionView.dequeueCell(withType: StyleCell.self, for: indexPath).then {
                    $0.configure(info: styleInfo)
                }
            default:
                return UICollectionViewCell()
            }
        })
    }

    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.bindClosets.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
            
            let section = self.bindClosets.value[sectionIndex]
            var layoutSection: NSCollectionLayoutSection?
            switch section {
            case .closets:
                layoutSection = self.closetsSectionLayout()
            default:
                layoutSection =  .init(group: .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))))
            }
            return layoutSection
        }
    
        return layout
    }
    
    func closetsSectionLayout() -> NSCollectionLayoutSection {
        
        // Size Property
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(210)
        )
        
        // Item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth + 16),
            heightDimension: .absolute(432)
        )
        
        
        // Group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(12)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
}


