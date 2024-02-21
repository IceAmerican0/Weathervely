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

public class ThemeTitleHeaderView: UICollectionReusableView {
    var bag = DisposeBag()
    private let container = UIView()
    var themeTitleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "#Title : 멋있는데 따뜻하게")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setContainerLayout()
    }
    
    func attribute() {
        themeTitleLabel.do {
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
    }
    
    func setContainerLayout() {
        self.addSubviews(container)
        container.pin.all()
        container.flex.layout()
    }
    
    func layout() {
        self.backgroundColor = .white
        
        container.flex.define {
            $0.addItem(themeTitleLabel).height(themeTitleLabel.font.setLineHeight()).width(100%)
        }
    }
    
    
    
}
