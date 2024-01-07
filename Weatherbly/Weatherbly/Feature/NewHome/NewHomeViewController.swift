//
//  NewHomeViewController.swift
//  Weatherbly
//
//  Created by Khai on 12/31/23.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxDataSources
import RxGesture
import Kingfisher

public enum ButtonTapAction {
    /// 이전 시간대
    case didTapPrev
    /// 다음 시간대
    case didTapNext
    /// 스타일 필터
    case didTapStyle
    /// 아이템 필터
    case didTapItem
}

final class NewHomeViewController: RxBaseViewController<NewHomeViewModel> {
    private let locationButton = UIButton().then {
        $0.setImage(.home_place, for: .normal)
    }
    
    private let regionLabel = LabelMaker(
        font: .body_1_M
    ).make(text: UserDefaultManager.shared.dong)
    
    private let notificationButton = UIButton().then {
        $0.setImage(.home_alarm, for: .normal)
    }
    
    private let prevButton = UIButton().then {
        $0.setImage(.home_date_left_dis, for: .normal)
    }
    
    private let dayLabel = LabelMaker(
        font: .body_5_B,
        fontColor: .gray70,
        alignment: .center
    ).make(text: "오늘").then {
        $0.backgroundColor = .gray10
        $0.setCornerRadius(14)
        $0.layer.masksToBounds = true
    }
    
    private let timeLabel = LabelMaker(
        font: .title_3_B,
        alignment: .center
    ).make(text: "오전 9시")
    
    private let nextButton = UIButton().then {
        $0.setImage(.home_date_right_nor, for: .normal)
    }
    
    private lazy var refresh = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    private lazy var homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    ).then {
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.refreshControl = refresh
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.register(withType: HomeForecastCell.self)
        $0.registerHeader(withType: ClosetFilterView.self)
        $0.register(withType: HomeClosetCell.self)
    }
    
    private lazy var dataSource = setDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define {
            $0.addItem().direction(.row).width(100%).marginTop(12).define { header in
                header.addItem(locationButton).marginLeft(20).size(20)
                header.addItem(regionLabel).marginLeft(8).grow(1)
            }.justifyContent(.spaceBetween).define { header in
                header.addItem(notificationButton).marginRight(20).size(20)
            }
            $0.addItem().direction(.row).justifyContent(.center).marginTop(11).define { date in
                date.addItem(prevButton).size(28)
                date.addItem(dayLabel).marginLeft(16).width(41).height(29)
                date.addItem(timeLabel).marginLeft(12)
                date.addItem(nextButton).marginLeft(16).size(28)
            }
            $0.addItem(homeCollectionView).marginTop(14).width(view.frame.width).height(500)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        regionLabel.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.toEditRegionView()
            }
            .disposed(by: bag)
        
        prevButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.buttonTapAction(action: .didTapPrev)
            }
            .disposed(by: bag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.buttonTapAction(action: .didTapNext)
            }
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        homeCollectionView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                
            }
            .disposed(by: bag)
        
        viewModel.refreshStatus
            .bind(with: self) { owner, refreshing in
                switch refreshing {
                case true:
                    owner.homeCollectionView.refreshControl?.beginRefreshing()
                case false:
                    owner.homeCollectionView.refreshControl?.endRefreshing()
                }
            }.disposed(by: bag)
        
        viewModel.homeSections
            .bind(to: homeCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    @objc
    func pullToRefresh() {
        viewModel.pullToRefresh()
    }
}

// MARK: UICollectionview UI & Delegate
extension NewHomeViewController: UICollectionViewDelegateFlowLayout {
    func setDataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSection>(configureCell: { [weak self] dataSource, collectionView, indexPath, _ in
            switch dataSource[indexPath] {
            case .forecast(let cellState):
                collectionView.dequeueCell(withType: HomeForecastCell.self, for: indexPath).then {
                    print("cellState: \(cellState)")
                    $0.configureCellState(state: cellState)
                }
            case .closet:
                collectionView.dequeueCell(withType: HomeClosetCell.self, for: indexPath)
            }
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableHeaderView(
                    withType: ClosetFilterView.self,
                    for: indexPath)
                
                if case .closet = dataSource[indexPath.section] {
                    header.itemTap
                        .drive(with: self, onNext: { owner, _ in
                            owner.viewModel.buttonTapAction(action: .didTapItem)
                        })
                        .disposed(by: self.bag)
                    
                    header.styleTap
                        .drive(with: self, onNext: { owner, _ in
                            owner.viewModel.buttonTapAction(action: .didTapStyle)
                        })
                        .disposed(by: self.bag)
                    
                    header.filterTap
                        .drive(with: self, onNext: { owner, _ in
                            owner.viewModel.buttonTapAction(action: .didTapItem)
                        })
                        .disposed(by: self.bag)
                    
                    
                    
                    return header
                }
                
                return UICollectionReusableView()
            default:
                return UICollectionReusableView()
            }
        })
        
        return dataSource
    }
    
    /// Header Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if case .closet = dataSource[section] {
            return CGSize(width: view.frame.width, height: 56)
        } else {
            return .zero
        }
    }
    
    /// Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if case .forecast = dataSource.sectionModels[indexPath.section] {
            return CGSize(width: 335, height: 150)
        }
        
        if case .closet = dataSource.sectionModels[indexPath.section] {
            return CGSize(width: 158, height: 236)
        }
        
        return .zero
    }
    
    /// Spacing Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
