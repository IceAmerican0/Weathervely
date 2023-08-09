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
import RxGesture

class HomeViewController: RxBaseViewController<HomeViewModel> {
    
    private var backgroundView = UIView()
    private var backgroundImage = UIImageView()
    private var topLayoutWrapper = UIView()
    private var settingButton = UIButton()
    private var mainLabelWrapper = UIView()
    private var mainLocationLabel = CSLabel(.bold, 20, "00동 | ")
    private var mainTimeLabel = CSLabel(.bold,20,"현재")
    private var calendarButton = UIButton()
    
    private var dailyWrapper = UIView()
    private var weatherImageView = UIImageView()
    private var temperatureLabel = CSLabel(.bold, 15, "")
    private var commentLabel = CSLabel(.regular, 18, "찬바람이 세차게 불어요")
    private var dustLabel = CSLabel(.regular, 17, "😷 미세 먼지가 매우 심해요")
    
    private var bottomWrapper = UIView()
    private lazy var pagerView = FSPagerView()
    
    private var bottomButtonWrapper = UIView()
    private var sensoryViewButton = CSButton(.primary)
//    var sensoryViewButton = UIButton()
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
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
        
        weatherImageView.do {
            $0.setAssetsImage(.weatherLoadingImage)
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
            $0.transformer = FSPagerViewTransformer(type: .linear)
        }
        
        sensoryViewButton.do {
            $0.setBackgroundImage(AssetsImage.gradientButton.image, for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setCornerRadius(30)
            $0.setBackgroundColor(.white)
            $0.setShadow(CGSize(width: 0, height: 0), nil, 0, 0)
            $0.setTitle("체감온도", for: .normal)
        }
        
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(topLayoutWrapper).direction(.row).marginTop(7).define { flex in
                flex.addItem(settingButton).size(44)
                flex.addItem(mainLabelWrapper).width(mainLabelWidth)
                    .justifyContent(.center)
                    .direction(.row)
                    .define { flex in
                        flex.addItem(mainLocationLabel)
                        flex.addItem(mainTimeLabel)
                    }
                flex.addItem(calendarButton).size(44)
            }
            
            flex.addItem(dailyWrapper)
                .width(110%)
                .alignItems(.center).define { flex in
                    flex.addItem(weatherImageView).marginTop(screenHeight * 0.008).width(screenWidth * 0.23).height(screenHeight * 0.1)
                    flex.addItem(temperatureLabel).marginTop(screenHeight * 0.01).width(50%).height(screenHeight * 0.03)
                    flex.addItem(commentLabel).marginTop(screenHeight * 0.004).height(screenHeight * 0.03)
                    flex.addItem(dustLabel).marginTop(screenHeight * 0.026).width(dustLabelWidth).height(45)
            }
            
            flex.addItem(pagerView).width(screenWidth).height(closetWrapperHeight + 20)
            flex.addItem(bottomButtonWrapper).direction(.row).define { flex in
                flex.addItem(sensoryViewButton).padding(3, 13.5)
            }
            
            pagerView.pin.top(to: dailyWrapper.edge.bottom).margin(screenHeight * 0.03)
            bottomButtonWrapper.pin.bottom(14)
        }
        
        backgroundView.flex.alignItems(.center).define { flex in
            flex.addItem(backgroundImage).marginHorizontal(-31).marginTop(-20).width(screenWidth + 62).height(backgroundImageHeight)
        }
    }
    
    override func viewBinding() {
        
        dailyWrapper.rx.swipeGesture([.left,.right])
            .when(.ended)
            .subscribe (onNext: { [weak self] dircection in
                // TODO: 현재시간 넣어서 보내기
//                self?.viewModel.swipeRight(0)
                if dircection.direction == .left {
                    // 시간대 뒤로
                    self?.viewModel.swipeLeft()
                } else {
                    // 시간대 앞으로
                    self?.viewModel.swipeRight(0)
                }
            })
            .disposed(by: bag)
        
        sensoryViewButton.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                // 지금 하이라이트 된 사진
                // 선택시간, 온도
                // 넣어서 화면 모달 띄우기
                self?.viewModel.toSensoryTempView()
            }).disposed(by: bag)
        
        dailyWrapper.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.toDailyForecastView()
            })
            .disposed(by: bag)

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
            .weatherImageRelay
            .subscribe(onNext: { [weak self] image in
                
                self?.weatherImageView.image = image
            })
            .disposed(by: bag)
        
        viewModel
            .villageForeCastInfoEntityRelay
            .subscribe(onNext: { [weak self] result in
                let todayInfo  = self?.viewModel.bindingDateWeather(result, 0, Date().today24Time)
                
                self?.setWeatherInfo(todayInfo, "현재")
                self?.viewModel.getWeatherImage(todayInfo)
            })
            .disposed(by: bag)
        
        /// [String: String]을 반환하는릴레이를 만든다음 구독하고있는다.
        /// 스와이프 할 때 날짜와 시간을 가지고 있는 릴레이를 만든다.
        /// 거기서 변경이 일어나면 [String: String]을 반환하는 함수를 호출한다...
        /// 1. 처음 쏠때 viewModel에서 Entity 방출
        /// 2. 그 entity로 뷰 멤핑 -> [String: String] 타입 방출받아서 setInfo에 해준다.
        /// 3. swipe하면 날짜, 타임 받아서  다시 [String: String] 방출 -> 멤핑
        ///
        /// 가능?
        
        viewModel
            .recommendClosetEntityRelay
            .subscribe(onNext: { [weak self] result in
                
//                guard let result = result else { return }
//                print(result.data!)
                self?.pagerView.reloadData()
            })
            .disposed(by: bag)
        
        viewModel.getInfo()
    }
    
    func setWeatherInfo(_ info: [String: String]?, _ mainTimeText: String) {
        
        guard let info = info else { return }
        let tmn = Int(Double(info["TMN"] ?? "-") ?? 0)
        let tmx = Int(Double(info["TMX"] ?? "-") ?? 0)
        
        mainTimeLabel.text = mainTimeText
        
        // TODO: - 위치 / 날씨 이모티콘 멥핑
        /// 위치 -> userDefault?
        
        temperatureLabel.do {
            $0.attributedText = NSMutableAttributedString()
            .bold("\(info["TMP"] ?? "-")℃", 20, CSColor.none)
                .regular(" (", 18, CSColor.none)
                .regular("\(tmn)", 18, CSColor._40_106_167)
                .regular(" / ", 18, CSColor.none)
                .regular("\(tmx)", 18, CSColor._178_36_36)
                .regular("℃)", 18, CSColor.none)
        }
    }
    
    private func configureBackgroundImage() -> AssetsImage {
        .cloudyEvening
    }
}

// MARK: FSPagerViewDelegate
extension HomeViewController: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        
        viewModel.highlightedCellIndexRelay.accept(index)
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
}

extension HomeViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        var count = 2
        guard viewModel.recommendClosetEntityRelay.value != nil else {
            return count
        }
        
        count = (viewModel.recommendClosetEntityRelay.value?.data?.list.count)!
        return count
        
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueCell(withType: ClosetFSPagerViewCell.self, for: index)
        let closetInfo = viewModel.recommendClosetEntityRelay.value?.data?.list[index]
        
        guard let closetInfo = closetInfo else {
            cell.clothImageSourceLabel.text = "loading.."
            cell.clothImageView.image = UIImage(systemName: "gear")
            
            return cell
        }
        
        if let url = URL(string: closetInfo.imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.setUIInfo(data, closetInfo.shopName)
                    }
                }
            }.resume()
        }
        
        return cell
    }
    

}
