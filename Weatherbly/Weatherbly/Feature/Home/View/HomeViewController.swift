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
import Kingfisher
import SafariServices

final class HomeViewController: RxBaseViewController<HomeViewModel> {
    private var backgroundView = UIView()
    private var backgroundImage = UIImageView()
    private var topLayoutWrapper = UIView()
    private var settingButton = UIButton()
    private var mainLabelWrapper = UIView()
    private var mainLabel = CSLabel(.bold, 20, "")
    private var calendarButton = UIButton()
    
    private var dailyWrapper = UIView()
    private var weatherImageView = UIImageView()
    private var temperatureLabelWrapper = UIView()
    private var temperatureLabel = CSLabel(.bold, 15, "")
    private var weatherCommentLabel = CSLabel(.regular, 18, "찬바람이 세차게 불어요")
    private var messageLabel = CSLabel(.regular, 17, "😷 미세 먼지가 매우 심해요")
    
    private lazy var pagerView = FSPagerView()
    
    private var bottomButtonWrapper = UIView()
//    private var sensoryViewButton = CSButton(.primary)
    var sensoryViewButton = UIButton()
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let backgroundImageHeight = UIScreen.main.bounds.height * 0.47
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.67
    private let dustLabelWidth = UIScreen.main.bounds.width * 0.89
    private let closetWrapperHeight = UIScreen.main.bounds.height * 0.43
    private let closetCellWidth = UIScreen.main.bounds.width * 0.44
    
    private let tapGesture = UITapGestureRecognizer()
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        view.bringSubviewToFront(container)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getInfo(self.date.todayHourFormat)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if UserDefaultManager.shared.isOnBoard == true {
            userDefault.removeObject(forKey: UserDefaultKey.isOnboard.rawValue)
            
            let toolTipView = MainToolTipViewController()
            toolTipView.delegate = self
            toolTipView.modalPresentationStyle = .overCurrentContext
            viewModel.presentViewControllerNoAnimationRelay.accept(toolTipView)
            
            weatherCommentLabel.isHidden = true
            messageLabel.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.pin.horizontally().top()
        backgroundView.flex.layout()
    }
    
    // MARK: Attribute
    override func attribute() {
        super.attribute()
        
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
            $0.numberOfLines = 0
        }
        
        messageLabel.do {
            $0.backgroundColor = .white
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 15
            $0.adjustsFontSizeToFitWidth = true
        }
        
        weatherCommentLabel.do {
            $0.numberOfLines = 0
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
            $0.setTitle("너의 온도는? 🥰", for: .normal)
        }
        
        mainLabel.do {
            $0.textAlignment = .center
        }
    }
    
    // MARK: Layout
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(topLayoutWrapper).direction(.row).marginTop(7).define { flex in
                flex.addItem(settingButton).size(44)
                flex.addItem(mainLabelWrapper).width(mainLabelWidth)
                    .justifyContent(.center)
                    .direction(.row)
                    .define { flex in
                        flex.addItem(mainLabel).width(100%)
                    }
                flex.addItem(calendarButton).size(44)
            }
            
            flex.addItem(dailyWrapper)
                .width(110%)
                .height(screenHeight * 0.208 + 45)
                .alignItems(.center).define { flex in
                    flex.addItem(weatherImageView).marginTop(screenHeight * 0.008).width(screenWidth * 0.23).height(screenHeight * 0.1)
                    flex.addItem(temperatureLabelWrapper).marginTop(screenHeight * 0.01).width(40%).height(screenHeight * 0.03)
                        .direction(.row)
                        .justifyContent(.center)
                        .define { flex in
                            flex.addItem(temperatureLabel).grow(1).shrink(1)
                    }
                    
                    flex.addItem(weatherCommentLabel).marginTop(screenHeight * 0.004).height(screenHeight * 0.03).width(50%)
//                    flex.addItem(dustLabel).marginTop(screenHeight * 0.026).width(dustLabelWidth).height(45)
            }
            
            flex.addItem(messageLabel).marginTop(-45).width(dustLabelWidth).height(45)
            flex.addItem(pagerView).width(screenWidth).height(closetWrapperHeight + 20)
            flex.addItem(bottomButtonWrapper).direction(.row).define { flex in
                flex.addItem(sensoryViewButton).padding(3, 13.5)
            }
            
            pagerView.pin.top(to: dailyWrapper.edge.bottom).margin(screenHeight * 0.03)
            bottomButtonWrapper.pin.bottom(14).marginHorizontal(62)
        }
        
        backgroundView.flex.alignItems(.center).define { flex in
            flex.addItem(backgroundImage).width(screenWidth).height(backgroundImageHeight)
        }
    }
    
    // MARK: ViewBind
    override func viewBinding() {
        super.viewBinding()
        
        mainLabel.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] tap in
                self?.viewModel.mainLabelTap()
            })
            .disposed(by: bag)
        
        dailyWrapper.rx.swipeGesture([.left,.right])
            .when(.ended)
            .subscribe (onNext: { [weak self] dircection in
                
                if dircection.direction == .left {
                    self?.viewModel.swipeDirectionRelay.accept(.left)
                    self?.viewModel.swipeLeft()
                    
                } else {
                    self?.viewModel.swipeDirectionRelay.accept(.right)
                    self?.viewModel.swipeRight()
                }
            })
            .disposed(by: bag)
        
        sensoryViewButton.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [weak self] _ in
                guard var selectedDate = self?.viewModel.selectedHourParamTypeRelay.value,
                      let closetId = self?.viewModel.highlightedClosetIdRelay.value,
                      let tempText = self?.temperatureLabel.text,
                        let selectedTime = self?.viewModel.headerTimeRelay.value
                else { return }
                
                let splittedTemp = tempText.split(separator: "℃").map{$0}
                let selectedTmp = "\(splittedTemp[0])℃"
                
                if self?.viewModel.headerTimeRelay.value == self?.date.todayThousandFormat && selectedDate != self?.date.todayHourFormat {
                    self?.viewModel.selectedHourParamTypeRelay.accept(self?.date.todayHourFormat)
                
                    let newSelectedDate = self?.viewModel.selectedHourParamTypeRelay.value
                    selectedDate = newSelectedDate ?? (self?.date.todayHourFormat)!
                }
                
                self?.viewModel.toSensoryTempView(selectedDate, selectedTime, selectedTmp, closetId)
            })
            .disposed(by: bag)
        
//        dailyWrapper.rx.tapGesture()
//            .subscribe(onNext: { [weak self] _ in
//                
//            })
//            .disposed(by: bag)

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
            .bind(onNext: { [weak self] _ in
                self?.viewModel.toTenDaysForecastView()
            })
            .disposed(by: bag)
    }
    
    // MARK: ViewModelBind
    override func viewModelBinding() {
        super.viewModelBinding()
        
        /// MARK: - 여기서 entity를 구독하는건 생각해볼 필요가 있다. entity 자체를 이용해서 바인딩해주기보다 이걸 멥핑해서 사용한다
        /// 그래서, 매핑한 값 bindingWeatherByDate 에 대한 return 값을 굳독해주는 게 더 맞아 보인다.
//        viewModel
//            .villageForeCastInfoEntityRelay
//            .subscribe(onNext: { [weak self] result in
//                // 2023-08-11 16:00
//                let todayInfo  = self?.viewModel.bindingWeatherByDate(result, 0, (self?.viewModel.headerTimeRelay.value!)!)
//
//                self?.setWeatherInfo(todayInfo, "현재")
//                self?.viewModel.getWeatherImage(todayInfo)
//            })
//            .disposed(by: bag)
        
        viewModel.dayChangedRelay
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.getInfo(self?.date.todayHourFormat ?? Date().todayHourFormat)
            })
            .disposed(by: bag)
        
        viewModel.hourChangedRelay
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.getInfo(self?.date.todayHourFormat ?? Date().todayHourFormat)
            })
            .disposed(by: bag)
        
        viewModel.mappedCategoryDicRelay
            .subscribe(onNext: { [weak self] mappedCategory in
                self?.reloadDailyWrapper(self?.viewModel.swipeDirectionRelay.value, mappedCategory)
            })
            .disposed(by: bag)
        
        viewModel
            .weatherImageRelay
            .subscribe(onNext: { [weak self] image in
                self?.weatherImageView.image = image
            })
            .disposed(by: bag)
        
        viewModel
            .recommendClosetEntityRelay
            .subscribe(onNext: { [weak self] result in
                guard result != nil else { return }
                self?.pagerView.reloadData()
                self?.viewModel.setCurrentMsg()
                self?.viewModel.setCurrentIndex((self?.pagerView.currentIndex)!)
            })
            .disposed(by: bag)
        
        viewModel.headerTimeRelay
            .subscribe(onNext: { [weak self] justTimeString in
                self?.setHeader(justTimeString)
            })
            .disposed(by: bag)
        
        viewModel.yesterdayCategoryRelay
            .subscribe (onNext: { [weak self] yesterdayInfo in
                guard let yesterdayInfo = yesterdayInfo,
                      let mainInfo = self?.viewModel.mappedCategoryDicRelay.value
                else { return }
                
                self?.setWeatherCommentLableInfo(yesterdayInfo, mainInfo)
            })
            .disposed(by: bag)
        
        viewModel.weatherMsgRelay
            .subscribe(onNext: { [weak self] message in
                
                guard let message = message else { return }
                self?.setWeatherMsgInfo(message)
               
            }).disposed(by: bag)
        
        viewModel.selectedHourParamTypeRelay
            .subscribe(onNext: { [weak self] _ in
                guard let image = self?.configureBackgroundImage() else { return }
                self?.backgroundImage.setAssetsImage(image)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Method
    
    func setWeatherCommentLableInfo(_ yesterDayInfo: [String : String], _ mainInfo: [String: String]) {
        
        let yesterdayTmp = Int(yesterDayInfo["TMP"]!)!
        let mainTmp = Int(mainInfo["TMP"]!)!
        
        let tempDiff = mainTmp - yesterdayTmp
        switch tempDiff {
        case ..<0:
            self.weatherCommentLabel.attributedText = NSMutableAttributedString()
                .regular("어제보다 \(tempDiff)℃ 낮아요", 17, CSColor.none)
        case 0:
            self.weatherCommentLabel.attributedText = NSMutableAttributedString()
                .regular("어제와 같은 기온이에요", 17, CSColor.none)
        case 1...:
            self.weatherCommentLabel.attributedText = NSMutableAttributedString()
                .regular("어제보다 \(tempDiff)℃ 높아요", 17, CSColor.none)
        default:
            break
        }
        
    }
    
    func setWeatherMsgInfo(_ weatherMsg: String) {
        guard ((self.viewModel.recommendClosetEntityRelay.value) != nil) else {
            self.messageLabel.attributedText = NSMutableAttributedString()
                .regular("\(weatherMsg)", 17, CSColor.none)
            return }
        var weatherMsg =  weatherMsg
        
        if self.viewModel.selectedHourParamTypeRelay.value == self.date.todayHourFormat {
            weatherMsg = WeatherMsgEnum.seonsoryDiffMsg((self.viewModel.recommendClosetEntityRelay.value?.data?.list.temperatureDifference)!).msg
        }
        self.messageLabel.attributedText = NSMutableAttributedString()
            .regular("\(weatherMsg)", 17, CSColor.none)
    }
    
    func reloadDailyWrapper (_ direction: UISwipeGestureRecognizer.Direction?, _ mappedCategory: [String : String]?) {
        if direction == .left {
            UIView.animate(withDuration: 0.2, animations: {
                self.dailyWrapper.alpha = 0
                self.setWeatherInfo(mappedCategory)
                self.viewModel.getWeatherImage(mappedCategory)
            }) { _ in
                // Position the label to the right for the fade-in effect
                self.dailyWrapper.transform = CGAffineTransform(translationX: 100, y: 0)
                
                UIView.animate(withDuration: 0.2) {
                    self.dailyWrapper.alpha = 1
                    self.dailyWrapper.transform = .identity // Reset to original position
                }
            }
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.dailyWrapper.alpha = 0
                self.setWeatherInfo(mappedCategory)
                self.viewModel.getWeatherImage(mappedCategory)
            }) { _ in
                // Position the label to the right for the fade-in effect
                self.dailyWrapper.transform = CGAffineTransform(translationX: -100, y: 0)
                
                UIView.animate(withDuration: 0.2) {
                    self.dailyWrapper.alpha = 1
                    self.dailyWrapper.transform = .identity // Reset to original position
                }
            }
        }
    }

    func setHeader(_ justTimeString: String?) {
        UIView.animate(withDuration: 0.2, animations: {
                              self.mainLabel.alpha = 0
            guard var mainTimeText = justTimeString else { return }
            
            // 처음 메인 들어왔을 시점을 위한 케이스 분류
            if mainTimeText == Date().todayThousandFormat {
                mainTimeText = "현재"
            }
            
            let dong = UserDefaultManager.shared.dong
            
            if !(mainTimeText == "현재") {
                self.mainLabel.attributedText = NSMutableAttributedString()
                    .bold("\(dong)  |  \(mainTimeText)", 20, CSColor.none)
                
            } else {
                self.mainLabel.attributedText = NSMutableAttributedString()
                    .bold("\(dong)  |  현재", 20, CSColor.none)
            }
            
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.mainLabel.alpha = 1
            }
        }
    }
    
    func setWeatherInfo(_ info: [String: String]?) {
        guard let info = info else { return }
        let tmn = Int(Double(info["TMN"] ?? "-") ?? 0)
        let tmx = Int(Double(info["TMX"] ?? "-") ?? 0)
        
        temperatureLabel.do {
            $0.attributedText = NSMutableAttributedString()
            .bold("\(info["TMP"] ?? "-")℃", 20, CSColor.none)
                .regular(" (", 16, CSColor.none)
                .regular("\(tmn)", 16, CSColor._40_106_167)
                .regular(" / ", 16, CSColor.none)
                .regular("\(tmx)", 16, CSColor._178_36_36)
                .regular("℃)", 16, CSColor.none)
        }
    }
    
    private func configureBackgroundImage() -> AssetsImage {
        guard let time = viewModel.selectedHourParamTypeRelay.value else { return .sunnyAfternoon }
        guard let image = viewModel.weatherImageRelay.value else { return .sunnyAfternoon }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:00"
            
        if let time = dateFormatter.date(from: time) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: time)
            
            switch hour {
            case 0..<7:
                return image == AssetsImage.sun.image || image == AssetsImage.moon.image ? .sunnyEvening : .cloudyEvening
            case 7..<15:
                return image == AssetsImage.sun.image ? .sunnyMorning : .cloudyMorning
            case 15..<20:
                return image == AssetsImage.sun.image || image == AssetsImage.moon.image ? .sunnyAfternoon : .cloudyAfternoon
            default:
                return .sunnyEvening
            }
        } else {
            return .sunnyAfternoon
        }
    }
}

// MARK: FSPagerViewDelegate
extension HomeViewController: FSPagerViewDelegate {
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        viewModel.setCurrentIndex(pagerView.currentIndex)
        viewModel.highlightedCellIndexRelay.accept(pagerView.currentIndex)
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if viewModel.highlightedCellIndexRelay.value == index {
            let closetInfo = viewModel.recommendClosetEntityRelay.value?.data?.list.closets[index]
            
            if let shopUrl = closetInfo?.shopUrl,
               let closetId = closetInfo?.id {
                
                viewModel.highlightedClosetIdRelay.accept(closetId)
                
                if let url = URL(string: shopUrl) {
                    let webView = SFSafariViewController(url: url)
                    webView.modalPresentationStyle = .overCurrentContext
                    viewModel.didEnterMall()
                    viewModel.presentViewControllerNoAnimationRelay.accept(webView)
                }
            }
        } else {
            pagerView.deselectItem(at: index, animated: true)
            pagerView.scrollToItem(at: index, animated: true)
        }
        viewModel.setCurrentIndex(index)
        viewModel.highlightedCellIndexRelay.accept(index)
    }
}

// MARK: FSPagerViewDataSource
extension HomeViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        var count = 5
        guard viewModel.recommendClosetEntityRelay.value != nil else {
            return count
        }
        
        count = (viewModel.recommendClosetEntityRelay.value?.data?.list.closets.count)!
        return count
        
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueCell(withType: ClosetFSPagerViewCell.self, for: index)
        let closetInfo = viewModel.recommendClosetEntityRelay.value?.data?.list.closets[index]
        
        cell.indicator.startAnimating()
        cell.indicator.isHidden = false
        
        if let imageUrl = closetInfo?.imageUrl, let shopName = closetInfo?.shopName {
            if let url = URL(string: imageUrl) {
                cell.clothImageView.kf.setImage(with: url,
                                                placeholder: nil,
                                                options: [.retryStrategy(DelayRetryStrategy(maxRetryCount: 2,
                                                                                            retryInterval: .seconds(2))),
                                                          .transition(.fade(0.1)),
                                                          .cacheOriginalImage]) { result in
                    switch result {
                    case .success:
                        cell.indicator.stopAnimating()
                        cell.indicator.isHidden = true
                        cell.clothImageSourceLabel.text = "by \(shopName)"
                    case .failure:
                        cell.indicator.stopAnimating()
                        cell.indicator.isHidden = true
                        cell.clothImageView.image = AssetsImage.defaultImage.image
                        cell.clothImageSourceLabel.text = ""
                    }
                }
            }
        }
        
        return cell
    }
}

extension HomeViewController: MainToolTipViewDelegate {
    func toolTipDismiss() {
        weatherCommentLabel.isHidden = false
        messageLabel.isHidden = false
    }
}
