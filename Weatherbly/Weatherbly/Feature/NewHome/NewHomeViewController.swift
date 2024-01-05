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

enum HomeSection {
    case forecast
    case filter
    case banner
    case closet
}

enum HomeCellState: Hashable {
    case forecast
    case filter
    case banner
    case closet
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
        $0.setImage(.home_date_left_dis, for: .disabled)
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
    
    private let timeLabel = LabelMaker(font: .title_3_B).make()
    
    private let nextButton = UIButton().then {
        $0.setImage(.home_date_right_nor, for: .normal)
    }
    
    var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeCellState>?
    
    private lazy var homeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: setLayout()
    ).then { [weak self] in
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(withType: HomeForecastCell.self)
        
        $0.register(withType: HomeClosetBannerCell.self)
        $0.register(withType: HomeClosetCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSource()
    }

    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define {
            $0.addItem().direction(.row).define { header in
                header.addItem(locationButton).marginLeft(20).size(20)
                header.addItem(regionLabel).marginLeft(8)
            }.justifyContent(.spaceBetween).define { header in
                header.addItem(notificationButton).marginRight(20).size(20)
            }
            $0.addItem().direction(.row).justifyContent(.center).define { date in
                date.addItem(prevButton).size(28)
                date.addItem(dayLabel).marginLeft(16).width(41).height(29)
                date.addItem(timeLabel).marginLeft(12)
                date.addItem(nextButton).marginLeft(16).size(28)
            }
            $0.addItem(homeCollectionView).marginTop(14).horizontally(20).grow(1)
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
    }
}

// MARK: UICollectionview UI & Delegate
extension NewHomeViewController: UICollectionViewDelegate {
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeCellState>(collectionView: self.homeCollectionView) { [weak self] (collectionView, indexPath, cellState) -> UICollectionViewCell? in
            guard let self else { return nil }
            
            switch cellState {
            case .forecast:
                let cell = collectionView.dequeueCell(withType: HomeForecastCell.self, for: indexPath)
            case .filter:
                return nil
            case .banner:
                let cell = collectionView.dequeueCell(withType: HomeClosetBannerCell.self, for: indexPath)
            case .closet:
                let cell = collectionView.dequeueCell(withType: HomeClosetCell.self, for: indexPath)
            }
            
            return nil
        }
    }
    
    private func setLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ -> NSCollectionLayoutSection? in
            if let section = self?.dataSource?.snapshot().sectionIdentifiers[section] {
                return nil
            } else {
                return nil
            }
        }
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = dataSource?.itemIdentifier(for: indexPath) else { return }
        
    }
}
