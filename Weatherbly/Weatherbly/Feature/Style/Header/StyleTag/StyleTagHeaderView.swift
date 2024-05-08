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

public class StyleTagHeaderView: UICollectionReusableView {
    var bag = DisposeBag()
    private let container = UIView()
    
    var tagCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 12
    }
    
    public lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagCollectionFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: StyleTagCell.self)
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
    
    func setContainerLayout() {
     
    }
    
    func layout() {
     
    }
    
    
    
}
