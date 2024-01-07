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

public final class ClosetFilterView: UICollectionReusableView {
    var bag = DisposeBag()
    private let container = UIView()
    
    private let styleFilterButton = UIButton().then {
        $0.setCornerRadius(14)
        $0.backgroundColor = .violet50
        $0.setTitle("스타일", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .body_5_B
        $0.imageView?.image = .home_drop_off
    }
    
    private let itemFilterButton = UIButton().then {
        $0.setCornerRadius(14)
        $0.backgroundColor = .violet50
        $0.setTitle("아이템", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .body_5_B
        $0.imageView?.image = .home_drop_off
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
}

extension ClosetFilterView {
    func layout() {
        backgroundColor = .clear
        addSubview(container)
        
        container.flex.direction(.row).define {
            $0.addItem(styleFilterButton).marginLeft(20).width(80).height(29)
            $0.addItem(itemFilterButton).marginLeft(8).width(80).height(29)
        }.justifyContent(.spaceBetween).define {
            $0.addItem(filterIcon).marginRight(20).size(24)
        }
    }
}
