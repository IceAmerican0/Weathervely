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
    case didTapPrev
    case didTapNext
    case didTapStyle
    case didTapItem
}

final class NewHomeViewController: RxBaseViewController<NewHomeViewModel> {
    
    private let headerContainer = UIView()
    
    private let locationButton = UIButton().then {
        $0.setImage(.home_place, for: .normal)
    }
    
    private let regionLabel = LabelMaker(
        font: .body_1_M
    ).make(text: UserDefaultManager.shared.dong)
    
    private let notificationButton = UIButton().then {
        $0.setImage(.home_alarm, for: .normal)
    }
    
    private let dateContainer = UIView()
    
    private let prevButton = UIButton().then {
        $0.setImage(.home_date_left_dis, for: .disabled)
    }
    
    private let dayLabel = LabelMaker(
        font: .body_5_B,
        fontColor: .gray70
    ).make(text: "오늘").then {
        $0.backgroundColor = .gray10
        $0.setCornerRadius(14)
    }
    
    private let timeLabel = LabelMaker(font: .title_3_B).make()
    
    private let nextButton = UIButton().then {
        $0.setImage(.home_date_right_nor, for: .normal)
    }
    
    private let homeForecastView = HomeForecastView()
    
    private let filterContainer = UIView()
    
    private let styleFilterButton = UIButton()
    
    private let itemFilterButton = UIButton()
    
    private let filterButton = UIButton().then {
        $0.setImage(.home_option, for: .normal)
    }
    
    private let closetCollectionView = UICollectionView()

    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define {
            $0.addItem(headerContainer).direction(.row).justifyContent(.spaceBetween).define { header in
                header.addItem(locationButton).marginLeft(20).size(20)
                header.addItem(regionLabel).marginLeft(8)
                header.addItem(notificationButton).size(20)
            }
            $0.addItem(dateContainer).direction(.row).justifyContent(.center).define { date in
                date.addItem(prevButton).size(28)
                date.addItem(dayLabel).marginLeft(16).width(41).height(29)
                date.addItem(timeLabel).marginLeft(12)
                date.addItem(nextButton).marginLeft(16).size(28)
            }
            $0.addItem(homeForecastView).marginTop(14).marginHorizontal(20)
            $0.addItem(filterContainer).direction(.row).justifyContent(.spaceBetween).define { filter in
                filter.addItem(styleFilterButton).width(80).height(29)
                filter.addItem(itemFilterButton).marginLeft(8).width(80).height(29)
                filter.addItem(filterButton).size(24)
            }
            $0.addItem(closetCollectionView).marginTop(13)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        regionLabel.rx.tapGesture()
            .when(.ended)
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
            .when(.ended)
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
