//
//  HomeViewController.swift
//  Weathervely
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import FSPagerView

class HomeViewController: BaseViewController {
    
    private var topLayoutWrapper = UIView()
    private var settingImageView = UIImageView()
    private var mainLabel = CSLabel(.bold, 20, "00동 | 현재")
    private var calendarImageView = UIImageView()
    
    private var weatherImageView = UIImageView()
    private var temperatureLabel = CSLabel(.bold, 15, "")
    private var commentLabel = CSLabel(.regular, 18, "찬바람이 세차게 불어요")
    private var dustLabel = CSLabel(.regular, 17, "😷 미세 먼지가 매우 심해요")
    
    private lazy var pagerView = FSPagerView()
    
    private var bottomButtonWrapper = UIView()
    private var todayButton = CSButton(.primary)
    private var tomorrowButton = CSButton(.primary)
    
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.67
    private let closetWrapperHeight = UIScreen.main.bounds.height * 0.43
    private let closetCellWidth = UIScreen.main.bounds.width * 0.44
    
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
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCalendarImage))
            $0.addGestureRecognizer(tap)
            $0.isUserInteractionEnabled = true
            
            $0.image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysOriginal)
            $0.tintColor = .gray
        }
        
        weatherImageView.do {
            $0.image = UIImage(systemName: "cloud.moon")
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
        
        pagerView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = true
            $0.backgroundColor = .white
            $0.register(ClosetCollectionViewCell.self, forCellWithReuseIdentifier: ClosetCollectionViewCell.identifier)
            $0.isInfinite = true
            $0.itemSize = CGSize(width: closetCellWidth, height: closetWrapperHeight)
            $0.transformer = FSPagerViewTransformer(type: .overlap)
            $0.interitemSpacing = 100
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
            flex.addItem(weatherImageView).marginTop(7).width(97).height(90)
            flex.addItem(temperatureLabel).marginTop(10).height(28)
            flex.addItem(commentLabel).marginTop(4).height(28)
            flex.addItem(dustLabel).marginTop(22).height(45)
            
            // CollectionView 세팅시 width, height 다 잡아줄것.. 아니면 안나옴
            flex.addItem(pagerView).marginTop(26).width(UIScreen.main.bounds.width).height(closetWrapperHeight)
            flex.addItem(bottomButtonWrapper).direction(.row).define { flex in
                flex.addItem(todayButton).marginRight(20).width(100).height(40)
                flex.addItem(tomorrowButton).marginLeft(20).width(100).height(40)
            }
            
            bottomButtonWrapper.pin.bottom(14)
        }
    }
    
    @objc private func didTapCalendarImage() {
        self.navigationController?.pushViewController(TenDaysForeCastViewController(), animated: true)
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
        return pagerView.dequeueCell(withType: ClosetCollectionViewCell.self, for: index).then {
            $0.clothImageView.image = UIImage(systemName: "gear")
            $0.clothImageSourceLabel.text = "by 0000"
        }
    }
}
