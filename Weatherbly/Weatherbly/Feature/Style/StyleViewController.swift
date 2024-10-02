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
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.register(withType: StyleTitleCell.self)
        $0.register(withType: StyleFilterCell.self)
        $0.register(withType: StyleCardCell.self)
    }
    
    private lazy var dataSource = setDataSource()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
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
                    if case .card(let item) = owner.dataSource[indexPath.section] {
                        owner.viewModel.toDetailView(id: item[row].closetId, temp: item[row].temperature.tempId)
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
    }
}

extension StyleViewController {
    
    // MARK: - InnerCV Cell Tap Event
    @objc func pushDetailView(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any],
            let selectedCloset = data["selectedCloset"] as? ClosetInfo {
            let detailVM = ClosetDetailViewModel(closetId: selectedCloset.closetId, tempId: selectedCloset.temperature.tempId)
            let detailVC = ClosetDetailViewController(detailVM)
            self.viewModel.navigationPushViewControllerRelay.accept(detailVC)
        }
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
                
            case .title(let title):
                return collectionView.dequeueCell(withType: StyleTitleCell.self, for: indexPath).then {
                    $0.configureCellState(text: title)
                }
                
            case .category(let types):
                return collectionView.dequeueCell(withType: StyleFilterCell.self, for: indexPath).then {
                    $0.configureCellState(state: types)
                    $0.buttonTap
                        .drive(with: self) { owner, _ in
//                            owner.viewModel.filterCloset(delegate: self)
                        }.disposed(by: $0.bag)
                }
            case .card(let info):
                return collectionView.dequeueCell(withType: StyleCardCell.self, for: indexPath).then {
                    $0.configure(info: info)
                }
                
            default: return UICollectionViewCell()
            }
            
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            
            if case UICollectionView.elementKindSectionHeader = kind {
                if case .tag(let types) = dataSource[indexPath.section] {
                    return collectionView.dequeueReusableHeaderView(withType: StyleTagHeaderView.self, for: indexPath).then {
                        $0.configureTag(types)
                    }
                }
            }
            
            return UICollectionReusableView()
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
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(56)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        // Section
        sectionHeader.pinToVisibleBounds = true
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
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
