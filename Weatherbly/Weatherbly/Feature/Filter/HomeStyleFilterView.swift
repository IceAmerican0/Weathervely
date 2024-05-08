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
    
    public lazy var styleListView = StyleListView()
    
    private let filterIcon = UIButton().then {
        $0.setImage(.home_option, for: .normal)
    }
    
    var buttonTap: Driver<Void> {
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
        layout()
    }
    
    public func configureCellState(state: [StyleTypeInfo]) {
        styleListView.reloadView(state: state)
    }
}

extension HomeStyleFilterView {
    private func layout() {
        backgroundColor = .white
        
        addSubview(styleListView)
        addSubview(filterIcon)
        
        styleListView.pin.before(of: filterIcon, aligned: .center).left().marginRight(20).height(29)
        filterIcon.pin.vCenter().right().size(24)
    }
}
