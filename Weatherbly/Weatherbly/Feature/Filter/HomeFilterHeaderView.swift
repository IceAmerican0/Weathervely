//
//  StyleFilterView.swift
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

public final class HomeFilterHeaderView: UICollectionReusableView {
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
        flex.layout()
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        flex.layout()
        return CGSize(width: size.width, height: 56)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    public func configureCellState(state: [StyleTypeInfo]) {
        styleListView.reloadView(state: state)
    }
}

extension HomeFilterHeaderView {
    private func layout() {
        backgroundColor = .white
        
        flex.direction(.row).alignItems(.center).justifyContent(.center).define {
            $0.addItem(styleListView).height(29).grow(1)
            $0.addItem(filterIcon).marginLeft(20).marginRight(0).size(24)
        }
    }
}
