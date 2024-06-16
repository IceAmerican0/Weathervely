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
        $0.setTitle("코디보기")
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData() {
            self.viewModel.bindSection()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.flex.layout()
    }
    
    override func layout() {
        super.layout()
        container.flex.define {
            $0.addItem(navigationBar)
            $0.addItem(parentCollectionView).grow(1).backgroundColor(.green)
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
                    $0.backgroundColor = .orange100
                }
            case .warmmer(let warmmerInfo):
                return collectionView.dequeueCell(withType: DiffTempCell.self, for: indexPath).then {
                    $0.backgroundColor = .yellow500
                }
            case .cooler(let coolerInfo):
                return collectionView.dequeueCell(withType: DiffTempCell.self, for: indexPath).then {
                    $0.backgroundColor = .blue100
                }
            }
        })
    }
    
    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in

            guard let self = self else { return nil }
            guard sectionIndex < self.viewModel.detailViewSections.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }

            let section = self.viewModel.detailViewSections.value[sectionIndex]
            switch section {
            case .mainDetail:
                return self.mainDetailLayout()
            case .withItem:
                return self.withItemLayout()
            case .warmmer:
                return self.mainDetailLayout()
            case .cooler:
                return self.mainDetailLayout()
            }
        }
    }

    func mainDetailLayout() -> NSCollectionLayoutSection {
        
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(606.5)
        )

        let item = NSCollectionLayoutItem(layoutSize: cellSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: cellSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    // StyleLayout
    func withItemLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(236)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        /// Group = 한 화면에 들어가는 item을 묶은 단위
        /// https://ios-development.tistory.com/945
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(236)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(16)

//        // Header
//        let headerSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .absolute(56)
//        )

//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerSize,
//            elementKind: UICollectionView.elementKindSectionHeader,
//            alignment: .top
//        )
//        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
//        sectionHeader.pinToVisibleBounds = true

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 10, bottom: 0, trailing: 0)

        section.interGroupSpacing = 12
        
//        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
}

