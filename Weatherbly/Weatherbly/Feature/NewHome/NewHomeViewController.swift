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
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private let nextButton = UIButton().then {
        $0.setImage(.home_date_right_nor, for: .normal)
    }
    
    private lazy var refresh = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 19
        $0.minimumLineSpacing = 19
        $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.sectionHeadersPinToVisibleBounds = true
    }
    
    private lazy var homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: setLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
//        $0.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        $0.backgroundColor = .clear
        $0.refreshControl = refresh
        $0.register(withType: HomeForecastCell.self)
        $0.registerHeader(withType: ClosetFilterHeaderView.self)
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
            $0.addItem().direction(.row).justifyContent(.spaceBetween).width(100%).marginTop(12).define { header in
                header.addItem(locationButton).marginLeft(20).size(20)
                header.addItem(regionLabel).marginLeft(8)
                header.addItem().grow(1)
                header.addItem(notificationButton).marginRight(20).size(20)
            }
            $0.addItem().direction(.row).justifyContent(.center).marginTop(11).define { date in
                date.addItem(prevButton).size(28)
                date.addItem(dayLabel).marginLeft(16).width(41).height(29)
                date.addItem(timeLabel).marginLeft(12)
                date.addItem(nextButton).marginLeft(16).size(28)
            }
            $0.addItem(homeCollectionView).marginTop(14).width(100%).grow(1)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
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
        
        homeCollectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        homeCollectionView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe { owner, indexPath in
                switch owner.dataSource[indexPath] {
                case .forecast:
                    owner.viewModel.toTendaysForecastView()
                case .closet(let cellState):
                    owner.viewModel.toDetailView(state: cellState)
                }
            }.disposed(by: bag)
        
        viewModel.refreshStatus
            .bind(with: self) { owner, refreshing in
                switch refreshing {
                case true:
                    owner.homeCollectionView.refreshControl?.beginRefreshing()
                case false:
                    owner.homeCollectionView.refreshControl?.endRefreshing()
                }
            }.disposed(by: bag)
        
        viewModel.selectedForecastState
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, info in
                    if info.date == "현재" {
                        owner.prevButton.setImage(.home_date_left_dis, for: .normal)
                        owner.prevButton.isUserInteractionEnabled = false
                    } else {
                        owner.prevButton.setImage(.home_date_left_nor, for: .normal)
                        owner.prevButton.isUserInteractionEnabled = true
                    }
                    
                    if (info.date == "내일") && (info.time == "오후 8시") {
                        owner.nextButton.setImage(.home_date_right_dis, for: .normal)
                        owner.nextButton.isUserInteractionEnabled = false
                    } else {
                        owner.nextButton.setImage(.home_date_right_nor, for: .normal)
                        owner.nextButton.isUserInteractionEnabled = true
                    }
                    owner.dayLabel.text = info.date
                    owner.timeLabel.text = "\(info.time)"
                }
            ).disposed(by: bag)
        
        viewModel.homeSections
            .bind(to: homeCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    @objc
    func pullToRefresh() {
        viewModel.pullToRefresh()
    }
}

// MARK: UICollectionview DataSource & UI & Delegate
extension NewHomeViewController: UICollectionViewDelegate {
    // MARK: DataSource
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
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableHeaderView(
                    withType: ClosetFilterHeaderView.self,
                    for: indexPath).then {
                        let state: ClosetFilterHeaderViewState = .init(
                            styleFilter: self.viewModel.filteredStyle,
                            itemFilter: self.viewModel.filteredItem
                        )
                        $0.configureViewState(state: state)
                    }
                
                if case .closet = dataSource[indexPath.section] {
                    header.itemTap
                        .drive(with: self, onNext: { owner, _ in
                            owner.viewModel.buttonTapAction(action: .didTapItem)
                        }).disposed(by: header.bag)
                    
                    header.styleTap
                        .drive(with: self, onNext: { owner, _ in
                            owner.viewModel.buttonTapAction(action: .didTapStyle)
                        }).disposed(by: header.bag)
                    
                    header.filterTap
                        .drive(with: self, onNext: { owner, _ in
                            owner.viewModel.buttonTapAction(action: .didTapStyle)
                        }).disposed(by: header.bag)
                    
                    return header
                }
                
                return UICollectionReusableView()
            default:
                fatalError("Cannot Generate SupplementaryView")
            }
        })
    }
    
    // MARK: UI
    func setLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            if let section = self?.dataSource[sectionIndex] {
                switch section {
                case .forecast:
                    return self?.setForecastLayout()
                case .closet:
                    return self?.setClosetLayout()
                }
            } else {
                return nil
            }
        }
    }
    
    /// 예보 Cell Layout
    func setForecastLayout() -> NSCollectionLayoutSection {
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(150)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: cellSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: cellSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 20, bottom: 14, trailing: 20
        )
        return section
    }
    
    /// 추천 Cell Layout
    func setClosetLayout() -> NSCollectionLayoutSection {
        let banner = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(158),
                heightDimension: .absolute(158)
            )
        )
        
        let bannerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: banner.layoutSize.heightDimension
            ),
            subitems: [banner]
        )
        bannerGroup.interItemSpacing = .fixed(19)
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(236)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: item.layoutSize.heightDimension
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(19)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(56)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 20, bottom: 0, trailing: 20
        )
        section.interGroupSpacing = 19
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

extension NewHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            UIEdgeInsets(top: 0, left: 20, bottom: 14, right: 20)
        } else {
            UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width - 40, height: 56)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width - 40, height: 150)
        }
        
        if indexPath.item == 0 {
            return CGSize(width: (collectionView.frame.width - 59) / 2, height: 158)
        } else {
            return CGSize(width: (collectionView.frame.width - 59) / 2, height: 236)
        }
    }
}
