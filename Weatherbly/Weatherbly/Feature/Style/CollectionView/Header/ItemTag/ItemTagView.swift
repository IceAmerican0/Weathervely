//
//  ItemTagcell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxGesture
import RxSwift
import RxCocoa
import Then

public enum SelectedChageState {
    case selected
    case deSelected
    
    init(value: Bool) {
        switch value {
        case true: self = .selected
        case false: self = .deSelected
        }
    }
}

public final class ItemTagView: UIView {
    
    public var bag = DisposeBag()
    public var selectedState = BehaviorRelay<SelectedChageState>(value: .deSelected)
    public var categoryInfo: CategoryInfo = .init(id: 0, name: "")
    
    public var labelWrapper = UIView().then {
        $0.layer.cornerRadius = 14
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray20.cgColor
        $0.clipsToBounds = true
    }
    
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center
    ).make(text: "#Item1").then {
        $0.numberOfLines = 1
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        binding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        setLayout()
        flex.layout(mode: .adjustWidth)
        return frame.size
    }
    
    var tagDidTap: Observable<UITapGestureRecognizer> {
        rx.tapGesture().when(.recognized)
    }
    
    private func binding() {
        selectedState.asDriver()
            .drive(with: self) { owner, isSelected in
                switch isSelected {
                case .selected:
                    owner.labelWrapper.do {
                        $0.layer.borderColor = UIColor.violet500.cgColor
                        $0.backgroundColor = UIColor.violet10
                    }
                    
                    owner.tagLabel.do {
                        $0.textColor = UIColor.violet500
                        $0.backgroundColor = UIColor.violet10
                    }
                case .deSelected:
                    owner.labelWrapper.do {
                        $0.layer.borderColor = UIColor.gray20.cgColor
                        $0.backgroundColor = .white
                    }
                    
                    owner.tagLabel.do {
                        $0.textColor = .black
                        $0.backgroundColor = .white
                    }
                }
            }.disposed(by: bag)
    }
    
    private func setLayout() {
        labelWrapper.pin.all()
        labelWrapper.flex.layout()
    }
    
    func layout() {
        flex.addItem(labelWrapper).maxWidth(300).height(29).justifyContent(.center).define {
            $0.addItem(tagLabel).marginHorizontal(14).grow(1)
        }
    }
    
    func configure(with tagInfo: CategoryInfo?, selectedTags: [Int]) {
        
        guard let tagInfo else {
            tagLabel.text = "#카테고리"
            tagLabel.flex.markDirty()
            return
        }
        
        if selectedTags.contains(tagInfo.id) {
            self.selectedState.accept(.selected)
        } else {
            self.selectedState.accept(.deSelected)
        }
        
        categoryInfo = tagInfo
        tagLabel.text = tagInfo.name
        tagLabel.flex.markDirty()
    }
}

