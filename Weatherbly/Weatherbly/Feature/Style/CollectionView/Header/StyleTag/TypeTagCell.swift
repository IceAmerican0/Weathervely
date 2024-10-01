//
//  StyleTagCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/9/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxGesture
import RxCocoa
import RxSwift

final class TypeTagCell: UICollectionViewCell {
    private var bag = DisposeBag()
    public weak var delegate: TypeTagDelegate?
    
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center
    ).make(text: "#tag")
    
    var typeTagInfo = CategoryInfo(id: 0, name: "tag")
    
//    var buttonTap: Driver<Void> {
//        self.listButton.rx.tap.asDriver()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        tagLabel.frame = bounds //  tagLabel이 부모 뷰를 완전히 덮도록 설정
        cellLayout()
    }
    
    private func attribute() {
        
        contentView.do {
            $0.layer.cornerRadius = 14
            $0.backgroundColor = UIColor.gray10
        }
        
        tagLabel.do {
            $0.numberOfLines = 1
        }
    }

    private func cellLayout() {
        contentView.addSubview(tagLabel)
        tagLabel.pin.all()
    }
    
    private func binding() {
        tagLabel.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _  in
                NotificationCenter.default.post(name: .styleTagTap, object: nil, userInfo: ["typeTagInfo" : owner.typeTagInfo])
            }.disposed(by: bag)
    }
    
    public func configure(typeInfo: CategoryInfo?) {
        if let info = typeInfo {
            self.typeTagInfo = info
            tagLabel.text = "#\(info.name)"
            layoutIfNeeded()
        }
    }
}
