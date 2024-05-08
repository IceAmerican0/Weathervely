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


final class StyleViewController: RxBaseScrollViewController<StyleViewModel> {
    
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "스타일").then {
        $0.backgroundColor = .red
    }
    
    private lazy var bannerView = UIImageView().then {
        $0.image = UIImage.style_banner
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = true
    }
    
    var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 16
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = PEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        $0.registerHeader(withType: ThemeTitleHeaderView.self)
        $0.register(withType: HorizontalCollectionViewCell.self)
//        $0.registerHeader(withType: <#T##T.Type#>)
    }
    
//    private lazy var firstThemeView = HorizonCollectionViewMolecule().then { [weak self] in
//        $0.collectionView.dataSource = self
//        $0.collectionView.delegate = self
//    }
//
//    private lazy var secoundThemeView = HorizonCollectionViewMolecule().then { [weak self] in
//        $0.collectionView.dataSource = self
//        $0.collectionView.delegate = self
//    }
//    
    private var screenDevider = UIImageView().then {
        $0.image = UIImage.style_screen_devider
    }
    var testData = ["look1", "look2", "look1", "look1", "look2", "look1", "look1", "look2", "look1", "look1", "look2"]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func layout() {
        super.layout()

        contentView.flex.define { flex in
            flex.addItem(titleLabel).height(titleLabel.font.setLineHeight()).margin(11.5, 20, 17.5)
            flex.addItem(bannerView).height(80).marginHorizontal(20).marginBottom(30)
//            flex.addItem(firstThemeView).height(244).paddingLeft(20).marginBottom(30)
//            flex.addItem(secoundThemeView).height(244).paddingLeft(20).marginBottom(30)
            flex.addItem(screenDevider).width(100%).height(16).marginBottom(30)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.recommendClosetEntityRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
//                    owner.collectionView.reloadData()
                }
            )
            .disposed(by: bag)
    }
    
    override func bind() {
        super.bind()
    }
    
}

extension StyleViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.testData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: HorizontalCollectionViewCell.self, for: indexPath)
      
        let image = UIImage(named: testData[indexPath.item])
        cell.imageView.image = image
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.frame.height)
    }
    
}

extension StyleViewController: UICollectionViewDelegate {
    
    // MARK: - DataSource
    func setDataSource() -> RxCollectionViewSectionedReloadDataSource<StyleSection> {
        RxCollectionViewSectionedReloadDataSource<StyleSection> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, _ in
            guard self != nil else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case .normal(let cellState):
                return collectionView.dequeueCell(withType: HorizontalCollectionViewCell.self, for: indexPath)
            }
        },configureSupplementaryView: { [ weak self ] dataSource, collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            
            if case UICollectionView.elementKindSectionHeader = kind {
                if case .normal = dataSource[indexPath.section] {
                    return collectionView.dequeueReusableHeaderView(
                        withType: HomeStyleFilterView.self,
                        for: indexPath
                    ).then {
                        let styleList: [StyleTypeInfo] = []
                        $0.configureCellState(state: styleList)
                    }
                }
            }
            return UICollectionReusableView()
        })
    }
}
