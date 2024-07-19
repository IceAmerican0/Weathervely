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
import SnapKit

struct TagState {
    var identfier: MCategoryInfo?
    var isSelected: SelectedChageState = .deSelected
}

class ItemTagView: UIView {
    
    var bag = DisposeBag()
    var itemTagDelegate: ItemTagDelegate?
    var selectedState: SelectedChageState = .deSelected
    var categoryInfo: MCategoryInfo = .init(id: 0, name: "")
    
    var labelWrapper = UIView()
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center
    ).make(text: "#Item1")
    
//    var tagState: TagState? {
//        didSet {
//            updateTag()
//        }
//    }
    
//    func updateTag() {
//        guard let tagState = tagState else { return }
//        tagLabel.text = tagState.identfier?.name
//        configureAttribute
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        layout()
        binding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectedToggle() {
        switch selectedState {
        case .selected:
            labelWrapper.layer.borderColor = UIColor.gray20.cgColor
            labelWrapper.backgroundColor = .white
            tagLabel.do {
                $0.textColor = .black
                $0.backgroundColor = .white
            }
            selectedState = .deSelected
        case .deSelected:
            labelWrapper.layer.borderColor = UIColor.violet500.cgColor
            labelWrapper.backgroundColor = UIColor.violet10
            tagLabel.do {
                $0.textColor = UIColor.violet500
                $0.backgroundColor = UIColor.violet10
            }
            selectedState = .selected
        }
    }

    func binding() {
        labelWrapper.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, event in
                owner.selectedToggle()
                owner.itemTagDelegate?.itemTagDidTap(categoryInfo: owner.categoryInfo)
            }.disposed(by: bag)
    }
    
    func configureAttribute() {
        
        labelWrapper.do {
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray20.cgColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
        tagLabel.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 1
            $0.clipsToBounds = true
            $0.textAlignment = .center
        }
    }
    
    func layout() {
        
        // ISSUE: - Pin 또는 Flex 사용할 경우 Layout 정상적으로 작동하지 않는다.
        // UIView의 라이프싸이클 문제로 추측 된다.
        addSubview(labelWrapper)
        labelWrapper.addSubview(tagLabel)
        labelWrapper.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.greaterThanOrEqualTo(30)
            $0.height.equalTo(29)
        }
        tagLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview()
            $0.width.greaterThanOrEqualTo(30)
        }
    }
    
    func configure(with tagInfo: MCategoryInfo?, selectedTags: [Int]) {
        
        guard let tagInfo = tagInfo else {
            tagLabel.text = "카테고리"
            tagLabel.sizeToFit()
            setNeedsLayout()
            return
        }
        if selectedTags.contains(tagInfo.id) {
            self.selectedState = .selected
        } else {
            self.selectedState = .deSelected
        }
        categoryInfo = tagInfo
        tagLabel.text = tagInfo.name
        tagLabel.sizeToFit()
        setNeedsLayout()
    }
        
    
}

