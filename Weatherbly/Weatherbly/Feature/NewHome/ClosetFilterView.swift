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
    
    private var config = {
        var config = UIButton.Configuration.filled()
        config.imagePlacement = NSDirectionalRectEdge.trailing
        config.image = UIImage.home_drop_off
        config.baseBackgroundColor = .gray10
        config.background.cornerRadius = 14
        config.imagePadding = 4
        return config
    }()
    
    private let handler: UIButton.ConfigurationUpdateHandler = {
        if case .selected = $0.state {
            $0.setTitleColor(.violet700, for: .normal)
            $0.configuration?.image = .home_drop_on
        } else {
            $0.setTitleColor(.black, for: .normal)
            $0.configuration?.image = .home_drop_off
        }
    }
    
    private lazy var styleFilterButton = UIButton(configuration: config).then {
        $0.setTitle("스타일", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .body_5_B
        $0.configurationUpdateHandler = handler
    }
    
    private lazy var itemFilterButton = UIButton(configuration: config).then {
        $0.setTitle("아이템", for: .normal)
        $0.setTitleColor(.black, for: .normal)
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
