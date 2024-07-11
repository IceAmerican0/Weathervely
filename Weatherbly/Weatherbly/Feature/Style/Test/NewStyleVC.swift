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
    
    lazy private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.registerHeader(withType: CategoryHeaderView.self)
        $0.register(withType: BannerCell.self)
        $0.register(withType: StyleCell.self)
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

extension NewStyleVC: UICollectionViewDelegate {
    
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
}
