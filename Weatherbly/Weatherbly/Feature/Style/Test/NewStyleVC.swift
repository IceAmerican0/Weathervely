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

final class NewStyleVC: RxBaseViewController<NewStyleViewModel> {
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "스타일").then {
        $0.sizeToFit()
    }
    
    lazy private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.registerHeader(withType: CategoryHeaderView.self)
        $0.register(withType: BannerCell.self)
        $0.register(withType: StyleCell.self)
        $0.register(withType: InnerCollectionViewCell.self)
    }
    
    private lazy var rxDataSources = setRxDataSources()
    
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
        
        container.flex.define { container in
            container.addItem(titleLabel).marginHorizontal(20).marginTop(11).marginBottom(17.5).height(23)
            container.addItem(collectionView).grow(1)
        }
        
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.bindSectionsRelay
            .bind(to: collectionView.rx.items(dataSource: setRxDataSources()))
            .disposed(by: bag)
    }
}

extension NewStyleVC: InnerCollectionViewCellDelegate {
    // MARK: - 이중 스크롤 방지
    func innerCollectionViewDidScroll(_ innerCollectionView: UICollectionView, contentOffset: CGPoint) {
        let offsetY = contentOffset.y
        let titleLabelAreaHeight = titleLabel.lineHeight + 28.5
        let bannerSectionHeight = CGFloat(80)
        let parentScrollOffsetY = titleLabelAreaHeight + bannerSectionHeight
        // InnerCollectionView의 스크롤을 상위 UICollectionView에 반영
                if offsetY <= 0 {
                    collectionView.contentOffset.y += offsetY
                    innerCollectionView.contentOffset.y = 0
                } else if collectionView.contentOffset.y < parentScrollOffsetY {
                    collectionView.contentOffset.y += offsetY
                    innerCollectionView.contentOffset.y = 0
                }
    }

}
extension NewStyleVC: UICollectionViewDelegate {
    // MARK: - 이중 스크롤 방지
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }

    // MARK: - DataSource
    
    func setRxDataSources() ->  RxCollectionViewSectionedReloadDataSource<NewStyleTabSectionModel> {
        RxCollectionViewSectionedReloadDataSource<NewStyleTabSectionModel> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .banner(let banner):
                return collectionView.dequeueCell(withType: BannerCell.self, for: indexPath).then {
                    $0.bannerImageView.image = banner.styleBanner
                }
                
            case .type(let innerSectionsArr):
                return collectionView.dequeueCell(withType: InnerCollectionViewCell.self, for: indexPath).then {
                    $0.delegate = self
                    $0.configure(innerSectionsArr)
                }
                
            case .styles(let styleInfo):
                return collectionView.dequeueCell(withType: StyleCell.self, for: indexPath).then {
                    $0.configure(info: styleInfo)
                }
            }
            
        }, configureSupplementaryView: { [ weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            // TODO: - header styleTagHeaderView 넣기
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                switch dataSource[indexPath.section] {
                    
                case .types(let types, _):
                    return collectionView.dequeueReusableHeaderView(withType: StyleTagHeaderView.self, for: indexPath).then {
                        $0.configureTag(types)
                    }
                case .styles(let headerInfo, _):
                    let header = collectionView.dequeueReusableHeaderView(withType: CategoryHeaderView.self, for: indexPath).then {
                        
                        $0.configure(info: headerInfo.typeInfo, categories: headerInfo.categories)
                    }
                    print(indexPath)
                    return header
                    // TODO: - /type API 데이터 붙이기
                    // TODO: - header 수정 -> ItemTagHeaderView + titleLabel 포함하게
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
    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.viewModel.bindSectionsRelay.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
    
            let section = self.viewModel.bindSectionsRelay.value[sectionIndex]
            var layoutSection: NSCollectionLayoutSection?
            switch section {
            case .banner:
                layoutSection = self.bannerSectionLayout()
            case .types:
                layoutSection = self.typesSectionLayout()
            case .styles:
                layoutSection = self.styleSectionLayout()
            }
             
            return layoutSection
        }
    
        return layout
    }
    
    func bannerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.screenWidth - 20),
            heightDimension: .absolute(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        return section
    }
    
    func typesSectionLayout() -> NSCollectionLayoutSection {
        
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
 
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(60)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        // Section
        sectionHeader.pinToVisibleBounds = true
        let section = NSCollectionLayoutSection(group: group)

        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
    func styleSectionLayout() -> NSCollectionLayoutSection {
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let groupWidth = itemWidth * 3 + 32
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(210)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(432)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .flexible(12)

        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(122)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )

        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
          section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
}
