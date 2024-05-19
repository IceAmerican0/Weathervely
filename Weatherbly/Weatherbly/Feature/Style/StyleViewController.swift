//
//  StyleViewController.swift
//  Weatherbly
//
//  Created by Khai on 10/16/23.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxDataSources
import RxGesture
import Kingfisher


final class StyleViewController: RxBaseViewController<StyleViewModel> {
    
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "스타일").then {
        $0.sizeToFit()
    }
    
    var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 16
        //        $0.itemSize = CGSize(width: 120, height: 209)
        
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()
    ).then {
        $0.showsHorizontalScrollIndicator = false
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.register(withType: BannerCell.self)
        $0.register(withType: StyleClosetCell.self)
    }
    
    private lazy var rxDataSources = setRxDataSources()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setMockDataSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        viewModel.styleSections
            .bind(to: collectionView.rx.items(dataSource: setRxDataSources()))
            .disposed(by: bag)
    }
    
}

extension StyleViewController: /*UICollectionViewDataSource,*/ UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.styleSections.value.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: 56)
        } else {
            return .zero
        }
    }
}

extension StyleViewController: UICollectionViewDelegate {
    
    // MARK: - DataSource
    func setRxDataSources() -> RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> {
        RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case .banner(let banner):
                let cell = collectionView.dequeueCell(withType: BannerCell.self, for: indexPath)
                cell.bannerImageView.image = banner.styleBanner
                return cell
            case .styles(let closetInfo):
                let cell = collectionView.dequeueCell(withType: StyleClosetCell.self, for: indexPath)
                cell.nameLabel.text = "\(indexPath)"
                cell.configureCell(closetInfo)
                return cell
            }
            
            
        }, configureSupplementaryView: { [ weak self ] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                if case .styles = dataSource[indexPath.section] {
                    let header = collectionView.dequeueReusableHeaderView(withType: StyleTagHeaderView.self, for: indexPath)
                    
                    return header
                }
            default:
                fatalError("Cannot Generate SupplemetaryView")
            }
            return UICollectionReusableView()
        })
    }
    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.viewModel.styleSections.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
            let section = self.viewModel.styleSections.value[sectionIndex]
            switch section {
            case .banner:
                return self.setBannerLayout()
            case .styles:
                return self.setStyleLayout()
            }
        }
    }
    
    func setBannerLayout() -> NSCollectionLayoutSection {
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: cellSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: cellSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    // StyleLayout
    func setStyleLayout() -> NSCollectionLayoutSection {
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(209)
        )
        let item = NSCollectionLayoutItem(layoutSize: cellSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 12, trailing: 0)
        
        /// Group = 한 화면에 들어가는 item을 묶은 단위
        /// https://ios-development.tistory.com/945
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(209)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(56)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        sectionHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 10, bottom: 0, trailing: 0)
        
        section.interGroupSpacing = 12
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

