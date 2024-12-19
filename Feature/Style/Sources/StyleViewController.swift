//
//  NewStyleVC.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import DesignSystem
import UIUtil
import UIKit
import RxSwift
import RxDataSources
import RxGesture

public protocol StyleViewDelegate {
    func detailTapped(closetID: Int, tempID: Int)
}

public final class StyleViewController: RxBaseViewController<StyleViewModel> {
    private let shimmerView = StyleShimmerView()
    
    private let contentView = UIView()
    
    private var titleLabel = LabelMaker(
        font: UIFont.title_3_B
    ).make(text: "스타일").then {
        $0.sizeToFit()
    }
    
    lazy private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: setSectionLayout()
    ).then {
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: BannerCell.self)
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.register(withType: StyleTitleCell.self)
        $0.register(withType: StyleFilterCell.self)
        $0.register(withType: StyleCardCell.self)
    }
    
    private lazy var headerView = StyleTagHeaderView().then {
        $0.delegate = self
        $0.isHidden = true
    }
    
    private lazy var dataSource = setDataSource()
    
    public var delegate: StyleViewDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getTypes()
    }
    
    public override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(shimmerView).grow(1)
            $0.addItem(contentView).grow(1).define {
                $0.addItem(titleLabel).marginHorizontal(20).marginTop(11.5).marginBottom(17.5).height(23)
                $0.addItem(collectionView).grow(1)
            }.display(.none)
        }
        container.addSubview(headerView)
    }
    
    public override func viewBinding() {
        super.viewBinding()
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, indexPath in
                    let row = indexPath.row
                    
                    if case .card(let item) = owner.dataSource[indexPath.section] {
                        owner.delegate?.detailTapped(closetID: item[row].closetId, tempID: item[row].temperature.tempId)
//                        owner.viewModel.toDetailView(id: item[row].closetId, temp: item[row].temperature.tempId)
                    }
                }
            ).disposed(by: bag)
    }
    
    public override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.dataSource
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.refreshList
            .bind(
                with : self,
                onNext: { owner, value in
                    owner.collectionView.performBatchUpdates({
                        owner.viewModel.dataSource.accept(value)
                    })
                }
            ).disposed(by: bag)
        
        viewModel.shimmerStatus
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(with: self) { owner, _ in
                owner.shimmerView.removeFromSuperview()
                owner.contentView.flex.display(.flex)
                owner.container.flex.layout()
            }.disposed(by: bag)
        
//        collectionView.rx.prefetchItems
//            .filter { indexPaths in
//                indexPaths.contains { $0.section == .card }
//            }
//            .subscribe(
//                with: self,
//                onNext: { owner, indexPaths in
//                    owner.viewModel.getNextCloset(indexPath: indexPaths)
//                }
//            ).disposed(by: bag)
    }
}

// MARK: CollectionViewDelegate
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
                    
                case .category(let type):
                    let cell = collectionView.dequeueCell(withType: StyleFilterCell.self, for: indexPath).then {
                        let section = ((indexPath.first ?? 3) / 3) - 1
                        let id = self.viewModel.types[section].id
                        $0.configureCellState(state: type, list: self.viewModel.categoryFilter[id] ?? [])
                    }
                    
                    cell.buttonTap
                        .drive(with: self) { owner, _ in
                            cell.listButton.isSelected.toggle()
                            owner.viewModel.getFilteredList(indexPath: indexPath, selected: type.id)
                        }.disposed(by: cell.bag)
                    
                    return cell
                case .card(let info):
                    return collectionView.dequeueCell(withType: StyleCardCell.self, for: indexPath).then {
                        let cellState = StyleCardCellState(
                            closetName: info.closetName,
                            imageURL: info.closetImageUrl
                        )
                        $0.configure(info: cellState)
                    }
                default:
                    return UICollectionViewCell()
                }
            }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
                guard let self else { return UICollectionReusableView() }
                
                if case UICollectionView.elementKindSectionHeader = kind {
                    if case .tag(let types) = dataSource[indexPath.section] {
                        return collectionView.dequeueReusableHeaderView(withType: StyleTagHeaderView.self, for: indexPath).then {
                            $0.configureState(state: types)
                            $0.delegate = self
                            self.headerView.configureState(state: types)
                        }
                    }
                }
                
                return UICollectionReusableView()
            })
    }
    
    // MARK: Layout
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
            heightDimension: .absolute(0.1)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(56)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerIndex = IndexPath(item: 0, section: 1)
        let sectionHeader = UICollectionView.elementKindSectionHeader
        let header = collectionView.layoutAttributesForSupplementaryElement(
            ofKind: sectionHeader,
            at: headerIndex
        )
        
        let yPosition = header?.frame.origin.y ?? 0
        let offsetY = scrollView.contentOffset.y
        
        let currentPosition = collectionView.indexPathsForVisibleItems.sorted().first ?? IndexPath(item: 0, section: 0)
        
        if offsetY > yPosition + 14 {
            if headerView.isHidden {
                headerView.isHidden = false
            }
            
            headerView.pin.top(to: titleLabel.edge.bottom).horizontally().height(56)
            headerView.autoScroll(to: (currentPosition.section - 2) / 3)
        } else {
            headerView.isHidden = true
            
            guard let tagHeader = collectionView.supplementaryView(
                forElementKind: sectionHeader,
                at: headerIndex
            ) as? StyleTagHeaderView else { return }
            tagHeader.autoScroll(to: 0)
        }
    }
}

extension StyleViewController: StyleTagHeaderViewDelegate {
    public func didTap(row: Int) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: row + (row + 1) * 2), at: .top, animated: true)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
//            guard let self else { return }
//            let position = self.collectionView.contentOffset
//            self.collectionView.setContentOffset(CGPoint(x: 0, y: position.y - 30), animated: false)
//        }
    }
}
