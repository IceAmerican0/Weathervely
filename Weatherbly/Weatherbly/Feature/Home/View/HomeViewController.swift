//
//  HomeViewController.swift
//  Weathervely
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import PinLayout
import FlexLayout
import FSPagerView
import RxSwift

class HomeViewController: RxBaseViewController<HomeViewModel> {
    
    private var backgroundView = UIView()
    private var backgroundImage = UIImageView()
    private var topLayoutWrapper = UIView()
    private var settingButton = UIButton()
    private var mainLabel = CSLabel(.bold, 20, "00동 | 현재")
    private var calendarButton = UIButton()
    
    private var dailyWrapper = UIView()
    private var weatherImageView = UIImageView()
    private var temperatureLabel = CSLabel(.bold, 15, "")
    private var commentLabel = CSLabel(.regular, 18, "찬바람이 세차게 불어요")
    private var dustLabel = CSLabel(.regular, 17, "😷 미세 먼지가 매우 심해요")
    
    private lazy var pagerView = FSPagerView()
    
    private var bottomButtonWrapper = UIView()
    private var todayButton = CSButton(.primary)
    private var tomorrowButton = CSButton(.primary)
    
    private let backgroundImageHeight = UIScreen.main.bounds.height * 0.47
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.67
    private let dustLabelWidth = UIScreen.main.bounds.width * 0.89
    private let closetWrapperHeight = UIScreen.main.bounds.height * 0.43
    private let closetCellWidth = UIScreen.main.bounds.width * 0.44
    
    private let tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        view.bringSubviewToFront(container)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.pin.horizontally().top()
        backgroundView.flex.layout()
    }
    
    override func attribute() {
        super.attribute()
        
        backgroundImage.do {
            $0.setAssetsImage(configureBackgroundImage())
        }
        
        settingButton.do {
            $0.setImage(AssetsImage.setting.image, for: .normal)
        }
        
        calendarButton.do {
            $0.setImage(AssetsImage.schedule.image, for: .normal)
        }
        
        dailyWrapper.do {
            $0.addGestureRecognizer(tapGesture)
        }
        
        weatherImageView.do {
            $0.setAssetsImage(.sunnyMain)
        }
        
        temperatureLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .bold("8℃", 20, CSColor.none)
                .regular(" (", 18, CSColor.none)
                .regular("-2", 18, CSColor._40_106_167)
                .regular("/", 18, CSColor.none)
                .regular("16", 18, CSColor._178_36_36)
                .regular("℃)", 18, CSColor.none)
        }
        
        dustLabel.do {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 15
        }
        
        pagerView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = true
            $0.register(ClosetFSPagerViewCell.self, forCellWithReuseIdentifier: ClosetFSPagerViewCell.identifier)
            $0.isInfinite = true
            $0.itemSize = CGSize(width: closetCellWidth, height: closetWrapperHeight)
            $0.transformer = FSPagerViewTransformer(type: .overlap)
            $0.interitemSpacing = 20
        }
        
        todayButton.do {
            $0.setTitle("오늘 옷차림", for: .normal)
        }
        
        tomorrowButton.do {
            $0.setTitle("내일 옷차림", for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        backgroundView.flex.alignItems(.center).define { flex in
            flex.addItem(backgroundImage).marginHorizontal(-31).marginTop(-20).width(UIScreen.main.bounds.width+62).height(backgroundImageHeight)
        }
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(topLayoutWrapper).direction(.row).marginTop(7).define { flex in
                flex.addItem(settingButton).size(44)
                flex.addItem(mainLabel).width(mainLabelWidth)
                flex.addItem(calendarButton).size(44)
            }
            flex.addItem(dailyWrapper).alignItems(.center).define { flex in
                flex.addItem(weatherImageView).marginTop(7).width(97).height(90)
                flex.addItem(temperatureLabel).marginTop(10).height(28)
                flex.addItem(commentLabel).marginTop(4).height(28)
                flex.addItem(dustLabel).marginTop(22).width(dustLabelWidth).height(45)
            }
            flex.addItem(pagerView).marginTop(26).width(UIScreen.main.bounds.width).height(closetWrapperHeight + 20)
            flex.addItem(bottomButtonWrapper).direction(.row).define { flex in
                flex.addItem(todayButton).marginRight(20).width(100).height(40)
                flex.addItem(tomorrowButton).marginLeft(20).width(100).height(40)
            }
            
            bottomButtonWrapper.pin.bottom(14)
        }
    }
    
    override func viewBinding() {
        tapGesture.rx
            .event
            .map { _ in
                DailyForecastViewController(EmptyViewModel())
            }
            .bind(to: viewModel.navigationPushViewControllerRelay)
            .disposed(by: bag)
        
        settingButton.rx.tap
            .bind(onNext: viewModel.toSettingView)
            .disposed(by: bag)
        
        calendarButton.rx.tap
            .bind(onNext: viewModel.toTenDaysForecastView)
            .disposed(by: bag)
    }
    
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel
            .villageForeCastInfoEntityRelay
            .subscribe(onNext: { [weak self] result in
                print(#function)
                let today  = self?.viewModel.bindingDateWeather(result, 0)
//                print(today)
//                self?.setInfo(categoryInfo)
            })
            .disposed(by: bag)
        
        /// [String: String]을 반환하는릴레이를 만든다음 구독하고있는다.
        /// 스와이프 할 때 날짜와 시간을 가지고 있는 릴레이를 만든다.
        /// 거기서 변경이 일어나면 [String: String]을 반환하는 함수를 호출한다...
        /// 1. 처음 쏠때 viewModel에서 
        viewModel.getVillageForecastInfo()
    }
    
    private func configureBackgroundImage() -> AssetsImage {
        .cloudyEvening
    }
}

// MARK: FSPagerViewDelegate
extension HomeViewController: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}

extension HomeViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int { 5 }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        return pagerView.dequeueCell(withType: ClosetFSPagerViewCell.self, for: index).then {
            $0.clothImageView.image = UIImage(systemName: "gear")
            $0.clothImageSourceLabel.text = "by 0000"
        }
    }
}
