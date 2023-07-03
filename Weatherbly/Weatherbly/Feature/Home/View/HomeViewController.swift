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
    private var mainLabel = CSLabel(.bold, 20, "00동 | 현재")
    private var calendarImageView = UIImageView()
    
    private var weatherImageView = UIImageView()
    private var temperatureLabel = CSLabel(.bold, 15, "")
    private var commentLabel = CSLabel(.regular, 18, "찬바람이 세차게 불어요")
    private var dustLabel = CSLabel(.regular, 17, "😷 미세 먼지가 매우 심해요")
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: SWInflateLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.register(withType: ClosetCollectionViewCell.self)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
            flex.addItem(collectionView).marginTop(26).width(UIScreen.main.bounds.width).height(closetWrapperHeight)
            flex.addItem(bottomButtonWrapper).direction(.row).define { flex in
                flex.addItem(todayButton).marginRight(20).width(100).height(40)
                flex.addItem(tomorrowButton).marginLeft(20).width(100).height(40)
            }
            
            bottomButtonWrapper.pin.bottom(14)
        }
    }
}

// MARK: CollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: ClosetCollectionViewCell.self, for: indexPath)
        cell.attribute()
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: closetCellWidth, height: closetWrapperHeight)
    }
}
