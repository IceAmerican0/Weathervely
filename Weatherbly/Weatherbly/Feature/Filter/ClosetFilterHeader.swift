//
//  ClosetFilterHeaderView.swift
//  Weatherbly
//
//  Created by Khai on 1/5/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

public struct ClosetFilterHeaderViewState {
    let styleFilter: Bool
    let itemFilter: Bool
}

public final class ClosetFilterHeaderView: UICollectionReusableView {
    var bag = DisposeBag()
    private let container = UIView()
    
    private var attributed: [NSAttributedString.Key: Any] = [
        .font: UIFont.body_5_B,
        .foregroundColor: UIColor.black
    ]
    
    private var config = {
        var config = UIButton.Configuration.filled()
        config.imagePlacement = NSDirectionalRectEdge.trailing
        config.image = UIImage.home_drop_off
        config.baseBackgroundColor = .gray10
        config.background.cornerRadius = 14
        config.imagePadding = 4
        return config
    }()
    
    private lazy var styleFilterButton = UIButton()
    
    private lazy var itemFilterButton = UIButton()
    
    private let filterIcon = UIButton().then {
        $0.setImage(.home_option, for: .normal)
    }
    
    var styleTap: Driver<Void> {
        self.styleFilterButton.rx.tap.asDriver()
    }
    
    var itemTap: Driver<Void> {
        self.itemFilterButton.rx.tap.asDriver()
    }
    
    var filterTap: Driver<Void> {
        self.filterIcon.rx.tap.asDriver()
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
        setLayout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        setLayout()
        return CGSize(width: size.width, height: 56)
    }
    
    public func configureViewState(state: ClosetFilterHeaderViewState) {
        styleFilterButton.configuration = config
        itemFilterButton.configuration = config
        
        var attString: NSAttributedString
        var (color, image) = buttonState(state: state.styleFilter)
        
        styleFilterButton.configuration?.baseBackgroundColor = color
        styleFilterButton.configuration?.image = image
        attString = NSAttributedString(string: "스타일", attributes: attributed)
        styleFilterButton.setAttributedTitle(attString, for: .normal)
        
        (color, image) = buttonState(state: state.itemFilter)
        itemFilterButton.configuration?.baseBackgroundColor = color
        itemFilterButton.configuration?.image = image
        attString = NSAttributedString(string: "아이템", attributes: attributed)
        itemFilterButton.setAttributedTitle(attString, for: .normal)
        setLayout()
    }
    
    private func buttonState(state: Bool) -> (UIColor,UIImage) {
        if state {
            attributed.updateValue(UIColor.violet700, forKey: .foregroundColor)
            return (.violet50, .home_drop_on)
        } else {
            attributed.updateValue(UIColor.black, forKey: .foregroundColor)
            return (.gray10, .home_drop_off)
        }
    }
}

extension ClosetFilterHeaderView {
    func setLayout() {
        container.pin.all()
        container.flex.layout()
    }
    
    func layout() {
        backgroundColor = .white
        
        self.flex.addItem(container).direction(.row).alignItems(.center).justifyContent(.spaceBetween).define {
            $0.addItem(styleFilterButton).width(80).height(29)
            $0.addItem(itemFilterButton).marginLeft(8).width(80).height(29)
            $0.addItem().grow(1)
            $0.addItem(filterIcon).size(24)
        }
    }
}
