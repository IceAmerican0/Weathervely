//
//  ItemTagcell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import PinLayout
import RxGesture
import RxSwift
import RxCocoa

enum SelectedChageState {
    case selected
    case deSelected
    
    init(value: Bool) {
        switch value {
        case true: self = .selected
        case false: self = .deSelected
        }
    }
}

class ItemTagView: UIView {
    
    var bag = DisposeBag()
    
    var stateChangeRealy = PublishRelay<ItemTagView>()
    var selectedState: SelectedChageState = .deSelected
    
    var labelWrapper = UIView()
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center
    ).make(text: "#Item1")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func binding() {
        tagLabel.rx.tapGesture()
            .bind(with: self) { owner, event in
                print("tap ItemTagView")
//                owner.stateChangeRealy.accept(self)
            }.disposed(by: bag)
    }
    
    func configureAttribute() {
        addSubview(labelWrapper)
        labelWrapper.addSubview(tagLabel)
        labelWrapper.do {
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray20.cgColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
        tagLabel.do {
//            $0.layer.cornerRadius = 14
//            $0.layer.borderWidth = 1
//            $0.layer.borderColor = UIColor.gray20.cgColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 1
            $0.clipsToBounds = true
            $0.textAlignment = .center
        }
    }
    
    func layout() {
        
        let g = self
        NSLayoutConstraint.activate([
            labelWrapper.topAnchor.constraint(equalTo: g.topAnchor, constant: 0),
            labelWrapper.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0),
            labelWrapper.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0),
            labelWrapper.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0),
            labelWrapper.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            labelWrapper.heightAnchor.constraint(equalToConstant: 29)
        ])
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: labelWrapper.topAnchor, constant: 0),
            tagLabel.leadingAnchor.constraint(equalTo: labelWrapper.leadingAnchor, constant: 14),
            tagLabel.trailingAnchor.constraint(equalTo: labelWrapper.trailingAnchor, constant: -14),
            tagLabel.bottomAnchor.constraint(equalTo: labelWrapper.bottomAnchor, constant: 0),
            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30.0),
        ])
    }
    

    
//    func configure(with text: String) {
//        tagLabel.text = text
//        tagLabel.sizeToFit()
//           setNeedsLayout()
//       }
    
}

