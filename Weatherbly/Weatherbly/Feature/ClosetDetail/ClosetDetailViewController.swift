//
//  ClosetDetailViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/5/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxDataSources

final class ClosetDetailViewController: RxBaseViewController<ClosetDetailViewModel> {
    
    let navigationBar = CSNavigationView(.leftButton(UIImage.leftArrow_black)).then {
        $0.setTitle(CSString.detailTitle.string)
    }
    
    lazy var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: 180, height: 200)
    }
    lazy var parentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: MainDetailCell.self)
        $0.register(withType: WithItemCell.self)
        $0.register(withType: DiffTempCell.self)
        $0.registerHeader(withType: DiffTempDecoHeader.self)
        $0.registerHeader(withType: TitleLabelReusableHeader.self)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.flex.layout()
    }
    
    override func layout() {
        super.layout()
        container.flex.define {
            $0.addItem(navigationBar)
            $0.addItem(parentCollectionView).grow(1)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        parentCollectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.detailViewSections
            .bind(to: parentCollectionView.rx.items(dataSource: setParentCollectionView()))
            .disposed(by: bag)
    }
}

extension ClosetDetailViewController: UICollectionViewDelegate {
    
    func setParentCollectionView() -> RxCollectionViewSectionedReloadDataSource<DetailViewSectionModel> {
        RxCollectionViewSectionedReloadDataSource<DetailViewSectionModel> (configureCell: {
            [weak self] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .mainDetail(let selectedInfo):
                return collectionView.dequeueCell(withType: MainDetailCell.self, for: indexPath).then {
                    $0.configure(info: selectedInfo)
                }
            case .withItem(let withItemInfo):
                return collectionView.dequeueCell(withType: WithItemCell.self, for: indexPath).then {
                    $0.configure(info: withItemInfo)
                }
            case .firstRow(let rowInfo),
                    .secondRow(let rowInfo):
                return collectionView.dequeueCell(withType: DiffTempCell.self, for: indexPath).then {
                    $0.configure(info: rowInfo)
                }
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                switch dataSource[indexPath.section] {
                case .mainDetail: return UICollectionReusableView()
                case .withItem:
                    return collectionView.dequeueReusableHeaderView(withType: TitleLabelReusableHeader.self, for: indexPath).then {
                        $0.configure(nil, text: "함께 착용한 아이템")
                    }
                case .warmFirst:
                    return collectionView.dequeueReusableHeaderView(withType: DiffTempDecoHeader.self, for: indexPath).then {
                        $0.configure(CSString.warmDiffTitle.string, CSString.warmDiffDescription.string)
                    }
                case .warmSecond:
                    return collectionView.dequeueReusableHeaderView(withType: TitleLabelReusableHeader.self, for: indexPath).then {
                        $0.configure(nil, text: "조금 더 따뜻한 옷")
                    }
                case .coolFirst:
                    return collectionView.dequeueReusableHeaderView(withType: DiffTempDecoHeader.self, for: indexPath).then {
                        $0.configure(CSString.coolDiffTitle.string, CSString.coolDiffDescription.string)
                    }
                case .coolSecond:
                    return collectionView.dequeueReusableHeaderView(withType: TitleLabelReusableHeader.self, for: indexPath).then {
                        $0.configure(nil, text: "조금 더 시원한 옷")
                    }
                }
            default:
                fatalError("Cannot Generate SupplementaryView")
            }
            return UICollectionReusableView()
        })
    }
    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.viewModel.detailViewSections.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
            
            let section = self.viewModel.detailViewSections.value[sectionIndex]
            var layoutSection: NSCollectionLayoutSection?
            switch section {
            case .mainDetail:
                layoutSection = self.mainDetailLayout()
            case .withItem:
                layoutSection = self.withItemLayout()
            case .warmFirst:
                let decoItem = NSCollectionLayoutDecorationItem.background(elementKind: "WarmDecorationView")
                layoutSection = self.firstRowLayout(decoItem)
            case .coolFirst:
                let decoItem = NSCollectionLayoutDecorationItem.background(elementKind: "CoolDecorationView")
                layoutSection = self.firstRowLayout(decoItem)
            case .warmSecond, .coolSecond:
                layoutSection = self.secondRowLayout()
            }
            return layoutSection
        }
        layout.register(WarmDecorationView.self, forDecorationViewOfKind: "WarmDecorationView")
        layout.register(CoolDecorationView.self, forDecorationViewOfKind: "CoolDecorationView")
        
        return layout
    }
    
    // MARK: - DiffTempSection Layout
    func firstRowLayout(_ decoItem: NSCollectionLayoutDecorationItem) -> NSCollectionLayoutSection {
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let groupWidth = itemWidth * 3 + 32
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(180)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(16)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16

        section.decorationItems = [decoItem]
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 19.5, leading: 20, bottom: 20, trailing: 0)
        return section
    }
    
    func secondRowLayout() -> NSCollectionLayoutSection {
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let groupWidth = itemWidth * 3 + 32
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(180)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(23)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 50, trailing: 0)
        return section
    }
    
    // MARK: - MainDetailSection Layout
    func mainDetailLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(606.5)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
        return section
    }
    
    // MARK: - withItemScction Layout
    func withItemLayout() -> NSCollectionLayoutSection {
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let groupWidth = itemWidth * 3 + 32
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(233)
//            heightDimension: .absolute(254) // FIXME: - 카테고리 영역 높이 = 21
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        /// Group = 한 화면에 들어가는 item을 묶은 단위
        /// https://ios-development.tistory.com/945
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(233)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(23)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12 , leading: 20, bottom: 30, trailing: 0)
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}

