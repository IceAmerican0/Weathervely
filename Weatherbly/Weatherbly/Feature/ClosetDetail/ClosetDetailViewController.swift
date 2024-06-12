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
    
    var parentCollectionView = UICollectionView().then {
        $0.register(withType: MainDetailCell.self)
        $0.register(withType: WithItemCell.self)
        $0.register(withType: DiffTempCell.self)
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
            case .withItem(let withItenInfo):
                return collectionView.dequeueCell(withType: WithItemCell.self, for: indexPath)
            case .warmmer(let warmmerInfo):
                return collectionView.dequeueCell(withType: DiffTempCell.self, for: indexPath)
            case .cooler(let coolerInfo):
                return collectionView.dequeueCell(withType: DiffTempCell.self, for: indexPath)
            }
        })
    }
    
}
