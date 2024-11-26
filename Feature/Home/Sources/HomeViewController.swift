//
//  HomeViewController.swift
//  Weatherbly
//
//  Created by Khai on 12/31/23.
//

import UIKit
import DesignSystem
import UIUtil
import RxSwift
import RxGesture
import RxDataSources
import FlexLayout

public enum ButtonTapAction {
    /// 이전 시간대
    case didTapPrev
    /// 다음 시간대
    case didTapNext
}

public protocol HomeViewDelegate {
    func locationTapped()
    func regionTapped()
    func notificationTapped()
    func forecastTapped()
    func filterTapped(delegate: HomeStyleFilterViewDelegate, selectedTime: String)
    func detailTapped(closetID: Int, tempID: Int)
}

public final class HomeViewController: RxBaseViewController<HomeViewModel> {
    private let shimmerView = HomeShimmerView()
    
    private let contentView = UIView()
    
    private let locationButton = UIButton().then {
        $0.setImage(.home_place, for: .normal)
    }
    
    private let regionLabel = LabelMaker(
        font: .body_1_M
    ).make().then {
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
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
        $0.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .clear
        $0.refreshControl = refresh
        $0.register(withType: HomeForecastSectionCell.self)
        $0.registerHeader(withType: HomeStyleFilterView.self)
        $0.register(withType: HomeClosetCell.self)
    }
    
    private lazy var dataSource = setDataSource()
    
    public var delegate: HomeViewDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getForecastInfo()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        regionLabel.text = UserDefaultManager.shared.dong
        regionLabel.flex.markDirty()
    }

    public override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(shimmerView).grow(1)
            $0.addItem(contentView).grow(1).define {
                $0.addItem().direction(.row).alignItems(.center).justifyContent(.spaceBetween).width(100%).height(44).define { header in
                    header.addItem(locationButton).marginLeft(20).size(20)
                    header.addItem(regionLabel).marginHorizontal(8).grow(1)
                    header.addItem(notificationButton).marginRight(20).size(20)
                }
                $0.addItem().direction(.row).alignItems(.center).justifyContent(.center).height(30).define { date in
                    date.addItem(prevButton).size(28)
                    date.addItem(dayLabel).marginLeft(16).width(41).height(29)
                    date.addItem(timeLabel).marginLeft(12).width(66).height(23)
                    date.addItem(nextButton).marginLeft(16).size(28)
                }
                $0.addItem(homeCollectionView).width(100%).grow(1)
            }.display(.none)
        }
    }
    
    public override func viewBinding() {
        super.viewBinding()
        
        locationButton.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.toMapView()
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
    
    public override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.shimmerStatus
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(with: self) { owner, _ in
                owner.shimmerView.removeFromSuperview()
                owner.contentView.flex.display(.flex)
                owner.container.flex.layout()
            }.disposed(by: bag)
        
        viewModel.selectedIndex
            .asDriver()
            .drive(with: self) { owner, index in
                owner.configureViewState(index: index)
            }.disposed(by: bag)
        
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
                    owner.scrollToTop()
                }
            }.disposed(by: bag)
        
        homeCollectionView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                if case let .closet(cellState) = owner.dataSource[indexPath] {
                    guard cellState.closetId >= 0 else { return }
                    owner.viewModel.stylePicked(closetID: cellState.closetId)
                    owner.viewModel.toDetailView(state: cellState)
                }
            }.disposed(by: bag)
        
//        homeCollectionView.rx.contentOffset
//            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMap { [weak self] offset -> Observable<Void> in
//                guard let self else { return Observable.empty() }
//                let contentHeight = self.homeCollectionView.contentSize.height
//                let height = self.homeCollectionView.frame.size.height
//                if offset.y > contentHeight - height - 100 {
//                    return Observable.just(())
//                }
//                return Observable.empty()
//            }
//            .bind(with: self) { owner, _ in
//                owner.viewModel.getNextCloset(of: 0)
//            }.disposed(by: bag)
        
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
    }
    
    @objc
    private func pullToRefresh() {
        viewModel.pullToRefresh()
    }
    
    private func scrollToTop() {
        Task { @MainActor in
            try await Task.sleep(for: .seconds(0.3))
            homeCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    private func configureViewState(index: Int) {
        let info = viewModel.forecastInfo
        if info.isEmpty { return }
        
        if index == 0 {
            prevButton.setImage(.home_date_left_dis, for: .normal)
            prevButton.isUserInteractionEnabled = false
        } else {
            prevButton.setImage(.home_date_left_nor, for: .normal)
            prevButton.isUserInteractionEnabled = true
        }
        
        if index + 1 == info.count {
            nextButton.setImage(.home_date_right_dis, for: .normal)
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.setImage(.home_date_right_nor, for: .normal)
            nextButton.isUserInteractionEnabled = true
        }
        
        dayLabel.text = info[index].date
        dayLabel.flex.markDirty()
        timeLabel.text = info[index].time ?? "오전 12시"
        timeLabel.flex.markDirty()
        
        viewModel.getClosetInfo()
    }
}

// MARK: RxCollectionview DataSource
extension HomeViewController {
    func setDataSource() -> RxCollectionViewSectionedReloadDataSource<HomeSection> {
        RxCollectionViewSectionedReloadDataSource<HomeSection> (configureCell: { [weak self] dataSource, collectionView, indexPath, _ in
            guard self != nil else { return UICollectionViewCell() }
            
            switch dataSource[indexPath] {
            case .forecast(let cellState):
                guard let self else { return UICollectionViewCell() }
                
                let cell = collectionView.dequeueCell(
                    withType: HomeForecastSectionCell.self,
                    for: indexPath
                )
                cell.configureCellState(state: cellState)
                
                viewModel.selectedIndex
                    .asDriver()
                    .drive(with: self) { owner, index in
                        if cellState.isEmpty { return }
                        
                        cell.swipePage(to: index)
                    }.disposed(by: cell.bag)
                
                cell.selectedIndex
                    .asDriver()
                    .drive(with: self) { owner, index in
                        if owner.viewModel.selectedIndex.value == index { return }
                        
                        if cell.currentIndex == index {
                            owner.viewModel.selectedIndex.accept(index)
                        }
                    }.disposed(by: cell.bag)
                
                cell.collectionView.rx.itemSelected
                    .bind(with: self) { owner, _ in
                        owner.delegate?.forecastTapped()
//                        owner.viewModel.toTendaysForecastView()
                    }.disposed(by: cell.bag)
                
                return cell
            case .closet(let cellState):
                return collectionView.dequeueCell(
                    withType: HomeClosetCell.self,
                    for: indexPath
                ).then {
                    if cellState.closetId == -1 {
                        $0.cloth.image = .home_banner_01
                        $0.cloth.contentMode = .scaleAspectFill
                    } else {
                        $0.configureCellState(imageURL: cellState.closetImageUrl)
                    }
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
                        let state = self.viewModel.styleFilterList
                        
                        $0.configureCellState(state: state)
                        
                        $0.buttonTap
                            .drive(with: self) { owner, _ in
                                owner.delegate?.filterTapped(
                                    delegate: self,
                                    selectedTime: owner.viewModel.selectedTime
                                )
//                                owner.viewModel.filterCloset(delegate: self)
                            }.disposed(by: $0.bag)
                        
                        $0.delegate = self
                        
                        $0.filterIcon.setImage(
                            UserDefaultManager.shared.homeItemFilterList.isEmpty ? .home_option : .home_option_set,
                            for: .normal
                        )
                    }
                }
            }
            return UICollectionReusableView()
        })
    }
}

// MARK: StyleListViewDelegate
extension HomeViewController: HomeStyleFilterViewDelegate {
    /// 스타일필터 선택시
    public func didTap() {
        scrollToTop()
        viewModel.getClosetInfo()
    }
}
