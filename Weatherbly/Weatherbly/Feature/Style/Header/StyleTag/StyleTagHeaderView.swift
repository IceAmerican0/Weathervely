//
//  ThemeTitleHeaderView.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/21/24.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout
import Then
import RxCocoa


public class StyleTagHeaderView: UICollectionReusableView {
    var bag = DisposeBag()
    
    //    public let tags = ["#비즈니스 캐주얼", "#캐주얼", "#시크", "#걸리시", "#레트로","#로맨틱", "#스트릿"]
    var tags: [ClosetTypeInfo] = []
    var tagsRelay = BehaviorRelay<[ClosetTypeInfo]>(value: [])
    
    lazy var tagCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
    }
    
    public lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagCollectionFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: StyleTagCell.self)
        $0.dataSource = self
        $0.delegate = self
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.flex.layout()
    }
    
    func layout() {
        self.flex.addItem(tagCollectionView).width(100%).height(56).direction(.row)
    }
    
    func configureTag(_ tagItem: [ClosetTypeInfo]?) {
        guard let tagItem = tagItem else { return }
        tagsRelay.accept(tagItem)   
    }
    
}


extension StyleTagHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsRelay.value.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: StyleTagCell.self, for: indexPath)
        cell.tagLabel.text = self.tagsRelay.value[indexPath.row].name
        cell.layoutIfNeeded()
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel().then {
            $0.font = UIFont.body_5_B
            $0.setLineHeight(UIFont.body_5_B.lineHeight)
            $0.text = tagsRelay.value[indexPath.item].name
            $0.sizeToFit()
        }
        
        let size = label.frame.size
        return CGSize(width: size.width + 28, height: size.height + 12)
    }
    
    

}


