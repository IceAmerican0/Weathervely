//
//  NewStyleVC.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import UIKit
import FlexLayout
import RxSwift
import RxDataSources
import RxGesture
import Then

public final class StyleViewController: RxBaseViewController<StyleViewModel> {
    private let shimmerView = StyleShimmerView()
    
    private let contentView = UIView()
    
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "스타일").then {
        $0.sizeToFit()
    }
    
    lazy private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: setSectionLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: BannerCell.self)
        $0.register(withType: TypeTagCell.self)
        $0.register(withType: StyleTitleCell.self)
        $0.register(withType: StyleFilterCell.self)
        $0.register(withType: StyleCardCell.self)
    }
    
    private lazy var dataSource = setDataSource()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getTypes()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(shimmerView).grow(1)
            $0.addItem(contentView).grow(1).define {
                $0.addItem(titleLabel).marginHorizontal(20).marginTop(11.5).marginBottom(17.5).height(23)
                $0.addItem(collectionView).grow(1)
            }.display(.none)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, indexPath in
                    let row = indexPath.row
                    
                    switch owner.dataSource[indexPath.section] {
                    case .tag: // 태그에 맞는 타이틀 위치로
                        owner.collectionView.scrollToItem(at: IndexPath(item: 0, section: row + (row + 1) * 2), at: .top, animated: true)
                    case .card(let item):
                        owner.viewModel.toDetailView(id: item[row].closetId, temp: item[row].temperature.tempId)
                    default: return
                    }
                }
            ).disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.dataSource
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.shimmerStatus
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(with: self) { owner, _ in
                owner.shimmerView.removeFromSuperview()
                owner.contentView.flex.display(.flex)
                owner.container.flex.layout()
            }.disposed(by: bag)
        
//        collectionView.rx.prefetchItems
//            .distinctUntilChanged()
//            .bind(with: self) { owner, indexPaths in
//                for indexPath in indexPaths {
//                    owner.viewModel.getNextCloset(indexPath: indexPath)
//                }
//            }.disposed(by: bag)
    }
}
    
extension StyleViewController: UICollectionViewDelegate {
    
    // MARK: - DataSource
    func setDataSource() -> RxCollectionViewSectionedAnimatedDataSource<StyleSection> {
        RxCollectionViewSectionedAnimatedDataSource<StyleSection> (
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case .banner:
                return collectionView.dequeueCell(withType: BannerCell.self, for: indexPath)
                
            case .tag(let tag):
                return collectionView.dequeueCell(withType: TypeTagCell.self, for: indexPath).then {
                    $0.configureCellState(text: tag.name)
                }
                
            case .title(let title):
                return collectionView.dequeueCell(withType: StyleTitleCell.self, for: indexPath).then {
                    $0.configureCellState(text: title)
                }
                
            case .category(let type):
                return collectionView.dequeueCell(withType: StyleFilterCell.self, for: indexPath).then {
                    $0.configureCellState(state: type)
                    $0.buttonTap
                        .drive(with: self) { owner, _ in
                            owner.viewModel.getFilteredList(indexPath: indexPath, selected: type.id)
                        }.disposed(by: $0.bag)
                }
            case .card(let info):
                return collectionView.dequeueCell(withType: StyleCardCell.self, for: indexPath).then {
                    $0.configure(info: info)
                }
            }
        })
    }
    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            return switch self.dataSource[sectionIndex] {
            case .banner:
                self.setBannerSection()
            case .tag:
                self.setTagSection()
            case .title:
                self.setTitleSection()
            case .category:
                self.setCategorySection()
            case .card:
                self.setCardSection()
            }
        }
    }
    
    func setBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }
    
    func setTagSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .absolute(56)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func setTitleSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(56)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(56)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    
    func setCategorySection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .absolute(29)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .absolute(66)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        group.interItemSpacing = .fixed(8)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func setCardSection() -> NSCollectionLayoutSection {
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(209)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(430)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        group.interItemSpacing = .fixed(12)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
}
