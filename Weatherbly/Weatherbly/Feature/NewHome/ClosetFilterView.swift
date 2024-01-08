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
        var config = UIButton.Configuration.plain()
        config.imagePlacement = NSDirectionalRectEdge.trailing
        config.image = UIImage.home_drop_off
        return config
    }()
    
    private lazy var styleFilterButton = UIButton().then {
        $0.setCornerRadius(14)
        $0.backgroundColor = .violet50
        $0.setTitle("스타일", for: .normal)
        $0.configuration = config
    }
    
    private lazy var itemFilterButton = UIButton().then {
        $0.setCornerRadius(14)
        $0.backgroundColor = .violet50
        $0.setTitle("아이템", for: .normal)
        $0.configuration = config
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
        return CGSize(width: size.width, height: 30)
    }
    
    public func configureViewState(state: ClosetFilterViewState) {
        if state.styleFilter {
            styleFilterButton.setTitleColor(.violet700, for: .normal)
            styleFilterButton.imageView?.image = .home_drop_on
        } else {
            styleFilterButton.setTitleColor(.black, for: .normal)
            styleFilterButton.imageView?.image = .home_drop_off
        }
        
        if state.itemFilter {
            itemFilterButton.setTitleColor(.violet700, for: .normal)
            itemFilterButton.imageView?.image = .home_drop_on
        } else {
            itemFilterButton.setTitleColor(.black, for: .normal)
            itemFilterButton.imageView?.image = .home_drop_off
        }
    }
}

extension ClosetFilterView {
    func layout() {
        backgroundColor = .clear
        addSubview(container)
        
        container.flex.direction(.row).define {
            $0.addItem(styleFilterButton).width(80).height(29)
            $0.addItem(itemFilterButton).marginLeft(8).width(80).height(29)
            $0.addItem().grow(1)
        }.justifyContent(.spaceBetween).define {
            $0.addItem(filterIcon).size(24)
        }
    }
}
