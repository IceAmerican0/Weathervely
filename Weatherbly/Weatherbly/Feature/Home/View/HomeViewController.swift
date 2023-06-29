//
//  HomeViewController.swift
//  Weathervely
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit

class HomeViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var topLayoutWrapper = UIView()
    private var settingImageView = UIImageView()
    private var mainLabel = CSLabel(.bold, 20, "00동 | 현재")
    private var calendarImageView = UIImageView()
    
    private var weatherImageView = UIImageView() // lottie?
    private var temperatureLabel = CSLabel(.bold, 15, "")
    private var commentLabel = CSLabel(.regular, 18, "찬바람이 세차게 불어요")
    private var dustLabel = CSLabel(.regular, 17, "😷 미세 먼지가 매우 심해요")
    
    private var closetWrapper = UIView()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: SWInflateLayout())
    
    private var bottomButtonWrapper = UIView()
    private var todayButton = CSButton(.primary)
    private var tomorrowButton = CSButton(.primary)
    
    private let mainLabelWidth = UIScreen.main.bounds.width * 0.67
    private let closetWrapperHeight = UIScreen.main.bounds.height * 0.43
    
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
            $0.image = UIImage(systemName: "cloud.moon")
        }
        
        temperatureLabel.do {
            $0.attributedText = NSMutableAttributedString()
                .bold("3℃", 20)
                .bold("-2/16℃", 18)
        }
        
        collectionView.do {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .white
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
            flex.addItem(closetWrapper).marginTop(26).height(closetWrapperHeight).define { flex in
                flex.addItem(collectionView)
            }
            flex.addItem(bottomButtonWrapper).direction(.row).marginTop(38).define { flex in
                flex.addItem(todayButton).marginRight(20).width(100).height(40)
                flex.addItem(tomorrowButton).marginLeft(20).width(100).height(40)
            }
        }
    }
}

// MARK: CollectionViewDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClosetCollectionViewCell", for: indexPath)
        return cell
    }
}
