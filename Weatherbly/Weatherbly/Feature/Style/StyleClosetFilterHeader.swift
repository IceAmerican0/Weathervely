//
//  StyleClosetFilterHeader.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/22/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

public class StyleClosetFilterHeader: UICollectionReusableView {
    var bag = DisposeBag()
    private let container = UIView()
    
    private let deviderWrapper = UIImageView().then {
        $0.image = UIImage.style_screen_devider
    }
    
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
    
    private let filterViewWrapper = UIView()
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
        setContainerLayout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func setContainerLayout() {
        self.addSubviews(container)
        container.pin.all()
        container.flex.layout()
    }
    
    func layout() {
        self.backgroundColor = .white
        
        container.flex.alignItems(.center).define {
            $0.addItem(deviderWrapper).height(16).width(100%)
            $0.addItem(filterViewWrapper).direction(.row).alignItems(.center).define {
                $0.addItem(styleFilterButton).width(80).height(29)
                $0.addItem(itemFilterButton).marginLeft(8).width(80).height(29)
                $0.addItem().grow(1)
            }.justifyContent(.spaceBetween).define {
                $0.addItem(filterIcon).size(24)
            }
        }
    }
}
