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
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.registerHeader(withType: ThemeTitleHeaderView.self)
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
            container.addItem(titleLabel).marginHorizontal(20).marginTop(11).marginBottom(9).height(23)
            container.addItem(collectionView).grow(1).backgroundColor(.green)
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
            var count = viewModel.styleSections.value.count
            return count
        }
    
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueCell(withType: StyleClosetCell.self, for: indexPath)
//    
//            let image = UIImage(named: testData[indexPath.item])
//            cell.imageView.image = image
//    
//            return cell
//        }
//    
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: 120, height: 180)
//        }
//    
}

extension StyleViewController: UICollectionViewDelegate {
    
    // MARK: - DataSource
    func setRxDataSources() -> RxCollectionViewSectionedReloadDataSource<StyleClosetSection> {
        RxCollectionViewSectionedReloadDataSource<StyleClosetSection> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .styles(let closetInfo):
                let cell = collectionView.dequeueCell(withType: StyleClosetCell.self, for: indexPath)

                return cell
            }
        }, configureSupplementaryView: { [ weak self ] dataSource, collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            
            switch dataSource.sectionModels[indexPath.section] {
            case .styles:
                let header = collectionView.dequeueReusableHeaderView(withType: ThemeTitleHeaderView.self, for: indexPath)
                return header
            }
        })
    }
}
