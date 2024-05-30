//
//  ItemTagHeaderView.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa


final class ItemTagHeaderView: UIView {
    var bag = DisposeBag()
    
    public var tagsRelay = BehaviorRelay<[String]>(value: [])
    public let tags = ["#니트/스웨터", "#후드 티셔츠", "#맨투맨/스웨트셔츠", "#긴소매 티셔츠", "#셔츠/블라우스","#피케/카라 티셔츠", "#반소매 티셔츠",
    "민소매 티셔츠","기타 상의","후드 집업","블루종/MA-1","레더/라이더스 재킷","무스탕/퍼","트러커 재킷","슈트/블레이저 재킷","카디건","아노락 재킷","플리스/뽀글이","스타디움 재킷","겨울 싱글 코트","겨울 더블 코트","겨울 기타 코트","숏패딩/숏헤비 아우터","패딩 베스트","베스트","사파리/헌팅 재킷","나일론/코치 재킷"]
    
//    lazy var itemTagHeaderFlowLayout = UICollectionViewFlowLayout().then {
//        $0.scrollDirection = .horizontal
//        $0.minimumLineSpacing = 8
//    }
    let itemTagHeaderFlowLayout = ItemHeaderFlowLayout()
    public lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: itemTagHeaderFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: ItemTagcell.self)
        $0.dataSource = self
        $0.delegate = self
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        self.flex.layout()
    }
    
    func layout() {
        self.flex.addItem(tagCollectionView).width(100%).height(66).direction(.row)
        
    }
    
    func configure() {
        tagsRelay.accept(tags)
    }
}

extension ItemTagHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return tags.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueCell(withType: ItemTagcell.self, for: indexPath)
           cell.configure(with: tags[indexPath.item])
           return cell
       }
       
//       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//           let tag = tags[indexPath.item]
//           let size = (tag as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)])
//           return CGSize(width: size.width + 20, height: collectionView.bounds.height / 2 - 10)
//       }
    
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueCell(withType: ItemTagcell.self, for: indexPath)
//        cell.tagLabel.text = self.tags[indexPath.row]
//        cell.contentView.backgroundColor = .blue
//        cell.layoutIfNeeded()
//        
//        return cell
//    }
//    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel().then {
            $0.font = UIFont.body_5_B
            $0.setLineHeight(UIFont.body_5_B.lineHeight)
            $0.text = tags[indexPath.item]
            $0.sizeToFit()
        }
        
        let size = label.frame.size
        return CGSize(width: size.width + 28, height: size.height + 12)
    }
 
}
