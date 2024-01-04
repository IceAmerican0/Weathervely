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
    
    private lazy var homeForecastView = HomeForecastView()
    
    private let styleFilterButton = UIButton()
    
    private let itemFilterButton = UIButton()
    
    private let filterButton = UIButton().then {
        $0.setImage(.home_option, for: .normal)
    }
    
    private var flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    private lazy var closetCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: flowLayout
    ).then { [weak self] in
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        
        $0.register(withType: HomeClosetBannerCell.self)
        $0.register(withType: HomeClosetCell.self)
    }

    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define {
            $0.addItem().direction(.row).justifyContent(.spaceBetween).marginHorizontal(20).define { header in
                header.addItem(locationButton).size(20)
                header.addItem(regionLabel).marginLeft(8)
                header.addItem(notificationButton).size(20)
            }
            $0.addItem().direction(.row).justifyContent(.center).define { date in
                date.addItem(prevButton).size(28)
                date.addItem(dayLabel).marginLeft(16).width(41).height(29)
                date.addItem(timeLabel).marginLeft(12)
                date.addItem(nextButton).marginLeft(16).size(28)
            }
//            $0.addItem(homeForecastView).marginTop(14).marginHorizontal(20).height(150)
//            $0.addItem().direction(.row).justifyContent(.spaceBetween).marginTop(14).define { filter in
//                filter.addItem(styleFilterButton).width(80).height(29)
//                filter.addItem(itemFilterButton).marginLeft(8).width(80).height(29)
//                filter.addItem(filterButton).size(24)
//            }
            $0.addItem(closetCollectionView).marginTop(14).horizontally(20).grow(1)
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
        
        homeForecastView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.toTendaysForecastView()
            }
            .disposed(by: bag)
        
        styleFilterButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.buttonTapAction(action: .didTapStyle)
            }
            .disposed(by: bag)
        
        itemFilterButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.buttonTapAction(action: .didTapItem)
            }
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.selectedForecastViewState
            .observe(on: MainScheduler.instance)
            .bind(onNext: { state in
                self.homeForecastView.configureViewState(viewState: state)
            })
            .disposed(by: bag)
    }
}

// MARK: UICollectionViewDelegate
extension NewHomeViewController: UICollectionViewDelegate {
}
