//
//  HomeStyleFilterView.swift
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

public final class HomeStyleFilterView: UICollectionReusableView {
    var bag = DisposeBag()
    
    public var styleListView = StyleListView()
    
    private let filterIcon = UIButton().then {
        $0.setImage(.home_option, for: .normal)
    }
    
    var buttonTap: Driver<Void> {
        self.filterIcon.rx.tap.asDriver()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    public func configureCellState(state: [StyleTypeInfo]) {
        styleListView.reloadView(state: state)
    }
    
    public func setDelegate(delegate: StyleListViewDelegate) {
        styleListView.delegate = delegate
    }
}

extension HomeStyleFilterView {
    private func setLayout() {
        backgroundColor = .white
        
        addSubview(styleListView)
        addSubview(filterIcon)
    }
    
    private func layout() {
        filterIcon.pin.vCenter().right().size(24)
        styleListView.pin.before(of: filterIcon, aligned: .center).left().marginRight(20).height(29)
    }
}
