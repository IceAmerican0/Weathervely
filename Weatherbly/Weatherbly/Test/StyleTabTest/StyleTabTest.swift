//
//  StyleTabTest.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/5/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxDataSources
import RxSwift

final class StyleTabTest: RxBaseViewController<StyleViewModel> {
    
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "스타일").then {
        $0.sizeToFit()
    }
    
    var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
        $0.sectionHeadersPinToVisibleBounds = true
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.registerFooter(withType: StyleTagHeaderView.self)
        $0.register(withType: BannerCell.self)
        $0.register(withType: StyleCell.self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func layout() {
        super.layout()
    }
    
    override func viewBinding() {
        super.viewBinding()
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
    }
}

extension StyleTabTest: UICollectionViewDelegate {
    func setRxDataSouces() -> RxCollectionViewSectionedReloadDataSource<StyleTabSectionModelTest> {
        RxCollectionViewSectionedReloadDataSource<StyleTabSectionModelTest> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .banner(let banner):
                return collectionView.dequeueCell(withType: BannerCell.self, for: indexPath).then {
                    $0.bannerImageView.image = banner.styleBanner
                }
            case .styles(let styleInfo):
                return collectionView.dequeueCell(withType: StyleCell.self, for: indexPath)
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                switch dataSource[indexPath.section] {
                case .banner:
                    return UICollectionReusableView()
                case .styles(let styleTagInfo, _):
//                    
//                    let header = collectionView.dequeueReusableHeaderView(withType: StyleTagHeaderView.self, for: indexPath)
//                    
//                    header.configureTag(styleTagInfo)
//                    // TODO: - /type API 데이터 붙이기
                    return UICollectionReusableView()
                }
            case UICollectionView.elementKindSectionFooter:
                switch dataSource[indexPath.section] {
                case .banner(_, let closetTypeInfo):
                    let footer = collectionView.dequeueReusableFooterView(withType: StyleTagHeaderView.self, for: indexPath)
                    footer.configureTag(closetTypeInfo)
                case .styles:
                    return UICollectionReusableView()
                }
            default:
                fatalError("Cannot Generate SupplemetaryView")
            }
            return UICollectionReusableView()
        })
    }
    
}//
