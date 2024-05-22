//
//  StyleCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

/// StyleViewController -> StyleCell -> { ItemTagHeaderView ( tagCollectionView + ItemTagCell) + closetCollectionView( HorizonClosetCell ) }

final class StyleCell: UICollectionViewCell {
    
    var bag = DisposeBag()
    
    
    var typeInfoRelay = BehaviorRelay<ClosetTypeInfo?>(value: ClosetTypeInfo(id: 1,name:"initial value"))
    var typeTitleLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "#Type1")
    
    lazy var closetCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 12
    }
    
    lazy var closetCollectionView = UICollectionView(frame: .zero, collectionViewLayout: closetCollectionFlowLayout).then {
        $0.registerHeader(withType: ItemTagHeaderView.self)
        $0.register(withType: HorizonClosetCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellLayout()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        
    }
    
    func cellLayout() {
        
        contentView.flex.height(516).define {
            $0.addItem(typeTitleLabel).marginVertical(16.5)
            $0.addItem(closetCollectionView).height(355)
        }
    }
    
    func binding() {
        typeInfoRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, typeInfo in
                    guard let tag = typeInfo else { return }
                    owner.typeTitleLabel.text = tag.name
                }).disposed(by: bag)
    }
    
    public func configure(_ type: ClosetTypeInfo?) {
        guard let type = type else { 
            self.typeTitleLabel.text = "# 기본값"
            return }
        typeInfoRelay.accept(type)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        binding()
    }
    
}
