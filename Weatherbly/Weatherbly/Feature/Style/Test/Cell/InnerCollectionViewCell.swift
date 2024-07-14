//
//  InnerCollectionViewCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import UIKit
import PinLayout
import RxDataSources
import RxSwift
import RxCocoa

final public class InnerCollectionViewCell: UICollectionViewCell {
    
    private var bag = DisposeBag()
    weak var delegate: InnerCollectionViewCellDelegate?
    private var bindSectionsRelay = BehaviorRelay<[NewStyleTabSectionModel]>(value: [])
    
    private lazy var innerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setInnerLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: StyleCell.self)
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.registerHeader(withType: CategoryHeaderView.self)
    }
    
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
        contentView.addSubview(innerCollectionView)
        innerCollectionView.pin.all()
    }
    
    func binding() {
        
        innerCollectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        bindSectionsRelay
            .bind(to: innerCollectionView.rx.items(dataSource: setInnerCollectionViewDataSource()))
            .disposed(by: bag)
    }
    
    func configure(_ sectionsInfo: [NewStyleTabSectionModel]?) {
        guard let sectionsInfo = sectionsInfo else { return }
        bindSectionsRelay.accept(sectionsInfo)
    }
    
}

extension InnerCollectionViewCell: UICollectionViewDelegate {
    func setInnerCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<NewStyleTabSectionModel> {
        RxCollectionViewSectionedReloadDataSource<NewStyleTabSectionModel> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .styles(let styleInfo):
                return collectionView.dequeueCell(withType: StyleCell.self, for: indexPath).then {
                    $0.configure(info: styleInfo)
                }
            default:
                return UICollectionViewCell()
            }
            
        }, configureSupplementaryView: { [ weak self ] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                switch dataSource[indexPath.section] {
                case .styles(let headerInfo, _):
                    let header = collectionView.dequeueReusableHeaderView(withType: CategoryHeaderView.self, for: indexPath).then {
                        $0.configure(info: headerInfo.typeInfo, categories: headerInfo.categories)
                        
                    }
                    return header
                    // TODO: - ItemTagHeaderView 이벤트 반드시 받아올 수 있어야 함.
                    
                default:
                    return UICollectionReusableView()
                }
            default:
                fatalError("Fail to Generate SupplementaryView")
            }
            return UICollectionReusableView()
        })
    }
    
    func setInnerLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.bindSectionsRelay.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
    
            let section = self.bindSectionsRelay.value[sectionIndex]
            var layoutSection: NSCollectionLayoutSection?
            switch section {
            case .styles:
                layoutSection = self.styleSectionLayout()
                
            default:
                layoutSection =  .init(group: .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))))
            }
             
            return layoutSection
        }
    
        return layout
    }
    
    func styleSectionLayout() -> NSCollectionLayoutSection {
        
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
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        group.interItemSpacing = .flexible(12)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(122)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
//        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 5)
        
        return section
    }
    
    // MARK: - 이중 스크롤 방지
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.innerCollectionViewDidScroll(innerCollectionView, contentOffset: scrollView.contentOffset)
    }

}
