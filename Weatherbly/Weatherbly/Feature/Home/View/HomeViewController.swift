//
//  HomeViewController.swift
//  Weathervely
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private var topLayoutWrapper = UIView()
    private var settingImageView = UIImageView()
    private var mainLabel = CSLabel(.bold, 20, "00동 | 오후 7시")
    private var calendarImageView = UIImageView()
    
    private var weatherImageView = UIImageView() // lottie?
    private var temperatureLabel = CSLabel(.bold, 15, "")
    private var commentLabel = CSLabel(.regular, 18, "찬바람이 세차게 불어요")
    private var dustLabel = CSLabel(.regular, 17, "😷 미세 먼지가 매우 심해요")
    
    private var previousClothWrapper = UIView()
    private var previousImageView = UIImageView()
    private var previousImageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    private var currentClothWrapper = UIView()
    private var currentImageView = UIImageView()
    private var currentImageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    private var nextClothWrapper = UIView()
    private var nextImageView = UIImageView()
    private var nextImageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    private var bottomButtonWrapper = UIView()
    private var todayButton = CSButton(.primary)
    private var tomorrowButton = CSButton(.primary)
    
    private var adBanner = UIView()
    
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.67
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func attribute() {
        super.attribute()
        
        settingImageView.do {
            $0.image = UIImage(systemName: "gear")?.withRenderingMode(.alwaysOriginal)
            $0.tintColor = .gray
        }
        
        calendarImageView.do {
            $0.image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysOriginal)
            $0.tintColor = .gray
        }
        
        weatherImageView.do {
            $0.image = UIImage(systemName: "")
        }
        
        temperatureLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .bold("3℃", 20)
                .bold("-2/16℃", 18)
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
        
        container.flex.alignItems(.center).marginHorizontal(20).define { flex in
            flex.addItem(topLayoutWrapper).direction(.row).marginTop(7).define { flex in
                flex.addItem(settingImageView).size(44)
                flex.addItem(mainLabel).width(mainLabelWidth)
                flex.addItem(calendarImageView).size(44)
            }
            flex.addItem(weatherImageView).marginTop(7)
            flex.addItem(temperatureLabel).marginTop(10)
            flex.addItem(commentLabel).marginTop(4)
            flex.addItem(dustLabel).marginTop(15)
            flex.addItem()
            flex.addItem(bottomButtonWrapper).direction(.row).marginTop(37).define { flex in
                flex.addItem(todayButton)
                flex.addItem(tomorrowButton)
            }
        }
    }
}
