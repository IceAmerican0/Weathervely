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
    /// 필터
    case didTapFilter
}

final class NewHomeViewController: RxBaseViewController<NewHomeViewModel> {
    private let locationButton = UIButton().then {
        $0.setImage(.home_place, for: .normal)
    }
    
    private let regionLabel = LabelMaker(
        font: .body_1_M
    ).make()
    
    private let notificationButton = UIButton().then {
        $0.setImage(.home_alarm, for: .normal)
    }
    
    private let prevButton = UIButton().then {
        $0.setImage(.home_date_left_dis, for: .normal)
        $0.isUserInteractionEnabled = false
    }
    
    private let dayLabel = LabelMaker(
        font: .body_5_B,
        fontColor: .gray70,
        alignment: .center
    ).make(text: "현재").then {
        $0.backgroundColor = .gray10
        $0.setCornerRadius(14)
        $0.layer.masksToBounds = true
    }
    
    private let timeLabel = LabelMaker(
        font: .title_3_B,
        alignment: .center
    ).make().then {
        $0.sizeToFit()
    }
    
    private let nextButton = UIButton().then {
        $0.setImage(.home_date_right_nor, for: .normal)
    }
    
    private lazy var refresh = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    private lazy var homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: HomeBannerLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        $0.backgroundColor = .clear
        $0.refreshControl = refresh
        $0.register(withType: HomeForecastCell.self)
        $0.registerHeader(withType: HomeStyleFilterView.self)
        $0.register(withType: HomeClosetCell.self)
    }
    
    private lazy var dataSource = setDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getForecastInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        regionLabel.text = UserDefaultManager.shared.dong
        regionLabel.flex.markDirty()
    }

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem().direction(.row).alignItems(.center).justifyContent(.spaceBetween).width(100%).height(44).define { header in
                header.addItem(locationButton).marginLeft(20).size(20)
                header.addItem(regionLabel).marginHorizontal(8).grow(1).shrink(1)
                header.addItem(notificationButton).marginRight(20).size(20)
            }
            $0.addItem().direction(.row).alignItems(.center).justifyContent(.center).height(30).define { date in
                date.addItem(prevButton).size(28)
                date.addItem(dayLabel).marginLeft(16).width(41).height(29)
                date.addItem(timeLabel).marginLeft(12).width(66).height(23)
                date.addItem(nextButton).marginLeft(16).size(28)
            }
            $0.addItem(homeCollectionView).marginTop(14).width(100%).grow(1)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        locationButton.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.toEditRegionView()
            }.disposed(by: bag)
        
        regionLabel.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.toEditRegionView()
            }.disposed(by: bag)
        
        notificationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.toNotificationListView()
            }.disposed(by: bag)
        
        prevButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.buttonTapAction(action: .didTapPrev)
            }.disposed(by: bag)
        
        timeLabel.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.didTapTimeLabel()
            }.disposed(by: bag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.buttonTapAction(action: .didTapNext)
            }.disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.homeSections
            .bind(to: homeCollectionView.rx.items(dataSource: dataSource))
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
        
        viewModel.selectedIndex
            .asDriver()
            .drive(with: self) { owner, index in
                if index == 0 {
                    owner.prevButton.setImage(.home_date_left_dis, for: .normal)
                    owner.prevButton.isUserInteractionEnabled = false
                } else {
                    owner.prevButton.setImage(.home_date_left_nor, for: .normal)
                    owner.prevButton.isUserInteractionEnabled = true
                }
                
                if index + 1 == 0 {
                    owner.nextButton.setImage(.home_date_right_dis, for: .normal)
                    owner.nextButton.isUserInteractionEnabled = false
                } else {
                    owner.nextButton.setImage(.home_date_right_nor, for: .normal)
                    owner.nextButton.isUserInteractionEnabled = true
                }
            }.disposed(by: bag)
        
        viewModel.selectedForecastState
            .bind(with: self) { owner, info in
                owner.dayLabel.text = info.date
                owner.dayLabel.flex.markDirty()
                owner.timeLabel.text = info.time ?? Date().currentTime()
                owner.timeLabel.flex.markDirty()
            }.disposed(by: bag)
        
        homeCollectionView.rx.prefetchItems
            .filter { indexPath in
                indexPath.contains { $0.section == 1 }
            }
            .compactMap { $0.last?.row }
            .distinctUntilChanged()
            .bind(with: self) { owner, row in
                guard row != 0 else { return }
                owner.viewModel.getNextCloset(of: row)
            }.disposed(by: bag)
        
        homeCollectionView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                switch owner.dataSource[indexPath] {
                case .forecast:
                    owner.viewModel.toTendaysForecastView()
                case .closet(let cellState):
                    owner.viewModel.stylePicked(closetID: cellState.closetId)
                    owner.viewModel.toDetailView(state: cellState)
                }
            }.disposed(by: bag)
    }
    
    @objc
    private func pullToRefresh() {
        viewModel.pullToRefresh()
    }
}

// MARK: UICollectionview DataSource
extension NewHomeViewController {
    func setDataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSection> {
        RxCollectionViewSectionedReloadDataSource<HomeSection> (configureCell: { [weak self] dataSource, collectionView, indexPath, _ in
            guard self != nil else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case .forecast(let cellState):
                return collectionView.dequeueCell(
                    withType: HomeForecastCell.self,
                    for: indexPath
                ).then {
                    $0.configureCellState(state: cellState)
                    
                    $0.swipeGesture
                        .when(.ended)
                        .bind(onNext: { [weak self] direction in
                            self?.viewModel.configureTime(direction: direction.direction)
                        }).disposed(by: $0.bag)
                }
            case .closet(let cellState):
                return collectionView.dequeueCell(
                    withType: HomeClosetCell.self,
                    for: indexPath
                ).then {
                    $0.configureCellState(state: cellState)
                }
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            // .closet일 경우에만 헤더를 넣어줌
            if case UICollectionView.elementKindSectionHeader = kind {
                if case .closet = dataSource[indexPath.section] {
                    return collectionView.dequeueReusableHeaderView(
                        withType: HomeStyleFilterView.self,
                        for: indexPath
                    ).then {
                        $0.configureCellState(state: self.viewModel.styleFilterList)
                        
                        $0.buttonTap
                            .drive(with: self, onNext: { owner, _ in
                                owner.viewModel.filterCloset()
                            }).disposed(by: $0.bag)
                    }
                }
            }
            return UICollectionReusableView()
        })
    }
}


