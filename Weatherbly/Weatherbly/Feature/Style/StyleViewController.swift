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
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.showsHorizontalScrollIndicator = false
//        $0.contentInset = PEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        $0.registerHeader(withType: ThemeTitleHeaderView.self)
        $0.register(withType: BannerCell.self)
        $0.register(withType: StyleClosetCell.self)
    }
    
    private lazy var rxDataSources = setRxDataSources()
    
    var testData: [StyleClosets] = [
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")]),
    StyleClosets(id: 1, name: "look1", imageUrl: "stat.fill", saleStatus: "ACTIVE", code: "100", style: [StyleInfo(styleID: 200, name: "name1")])]
    
    
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
        
        viewModel.recommendClosetEntityRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
//                    owner.collectionView.reloadData()
                }
            )
            .disposed(by: bag)
        
        // TODO: Delete TestCode
        viewModel.styleSections.accept(testData)
          
        viewModel.styleSections
            .bind(to: self.collectionView.rx.items(dataSource: setRxDataSources()))
            .disposed(by: bag)
        
    }
    
    
}

extension StyleViewController: /*UICollectionViewDataSource,*/ UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return self.testData.count
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        let cell = collectionView.dequeueCell(withType: StyleClosetCell.self, for: indexPath)
    //
    //        let image = UIImage(named: testData[indexPath.item])
    //        cell.imageView.image = image
    //
    //        return cell
    //    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 120, height: collectionView.frame.height)
//    }
    
}

extension StyleViewController: UICollectionViewDelegate {
    
    // MARK: - DataSource
    func setRxDataSources() -> RxCollectionViewSectionedReloadDataSource<StyleClosetSection> {
        RxCollectionViewSectionedReloadDataSource<StyleClosetSection> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, _ in
            print("here")
            guard self != nil else { return UICollectionViewCell() }
            
            print("whats it : \(dataSource[indexPath])")
            
            let cell = collectionView.dequeueCell(withType: StyleClosetCell.self, for: indexPath)
            
            cell.
//            switch dataSource[indexPath] {
//            case .banner(let image):
//                return collectionView.dequeueCell(withType: BannerCell.self, for: indexPath).then {
//                    $0.bannerImageView.image = UIImage.style_banner
//                    $0.backgroundColor = .red
//                }
//            case .styles(let closetInfo):
//                return collectionView.dequeueCell(withType: StyleClosetCell.self, for: indexPath)
//            }
        }
                                                                       
                                                                       /*,configureSupplementaryView: { [ weak self ] dataSource, collectionView, kind, indexPath in
          guard let self else { return UICollectionReusableView() }
          
          switch kind {
          case UICollectionView.elementKindSectionHeader:
          let header = collectionView.dequeueReusableHeaderView(withType: ClosetFilterHeader.self, for: indexPath).then {
          let state: ClosetFilterHeaderViewState = .init(
          styleFilter: self.viewModel.filteredStyle,
          itemFilter: self.viewModel.filteredItem
          )
          $0.configureViewState(state: state)
          }
          
          if case .styles = dataSource[indexPath.section] {
          header.styleTap
          .drive(with: self, onNext: { owner, _ in
          owner.viewModel.filterCloset(state: .style)
          }).disposed(by: header.bag)
          
          header.filterTap
          .drive(with: self, onNext: { owner, _ in
          owner.viewModel.filterCloset(state: .item)
          }).disposed(by: header.bag)
          return header
          }
          
          return UICollectionReusableView()
          default:
          fatalError("Cannot Generate SupplementaryView")
          }
          
          }*/)
    }
}
