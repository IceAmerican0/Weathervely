//
//  ClosetFilterView.swift
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

public struct ClosetFilterViewState {
    let styleFilter: Bool
    let itemFilter: Bool
}

public final class ClosetFilterView: UICollectionReusableView {
    var bag = DisposeBag()
    private let container = UIView()
    
    private var attributed: [NSAttributedString.Key: Any] = [
        .font: UIFont.body_5_M,
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
    
    private var handler: UIButton.ConfigurationUpdateHandler = {
//        var attribute: [NSAttributedString.Key: Any] = [
//            .font: UIFont.body_5_M,
//            .foregroundColor: UIColor.black
//        ]

        if case .selected = $0.state {
//            attribute.updateValue(UIColor.violet700, forKey: .foregroundColor)
            $0.configuration?.image = .home_drop_on
        } else {
            $0.configuration?.image = .home_drop_off
        }
        
//        let attString = NSAttributedString(string: $0.titleLabel?.text ?? "", attributes: attribute)
//        $0.setAttributedTitle(attString, for: .normal)
    }
    
    private lazy var styleFilterButton = UIButton(configuration: config).then {
        let attString = NSAttributedString(string: "스타일", attributes: attributed)
        $0.setAttributedTitle(attString, for: .normal)
        $0.configurationUpdateHandler = handler
    }
    
    private lazy var itemFilterButton = UIButton(configuration: config).then {
        let attString = NSAttributedString(string: "아이템", attributes: attributed)
        $0.setAttributedTitle(attString, for: .normal)
        $0.configurationUpdateHandler = handler
    }
    
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
        self.itemFilterButton.rx.tap.asDriver()
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
        container.pin.all()
        container.flex.layout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        pin.width(size.width)
        flex.layout()
        return CGSize(width: size.width, height: 56)
    }
    
    public func configureViewState(state: ClosetFilterViewState) {
        if state.styleFilter {
            styleFilterButton.isSelected = true
        } else {
            styleFilterButton.isSelected = false
        }
        
        if state.itemFilter {
            itemFilterButton.isSelected = true
        } else {
            itemFilterButton.isSelected = false
        }
    }
}

extension ClosetFilterView {
    func layout() {
        backgroundColor = .white
        
        self.flex.addItem(container).direction(.row).alignItems(.center).define {
            $0.addItem(styleFilterButton).width(80).height(29)
            $0.addItem(itemFilterButton).marginLeft(8).width(80).height(29)
            $0.addItem().grow(1)
        }.justifyContent(.spaceBetween).define {
            $0.addItem(filterIcon).size(24)
        }
    }
}
