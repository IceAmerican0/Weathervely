//
//  HorizonCollectionViewMoleCule.swift
//  Weatherbly
//
//  Created by 최수훈 on 1/29/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

public class HorizonCollectionViewMoleCule: UIView,CodeBaseInitializerProtocol {

    public var themeTitleLabel = LabelMaker(font: UIFont.title_3_B).make("#Title: 멋있는데 따뜻하게")
    public var collectionView = UICollectionView()
    public let collectionViewLayer = UICollectionViewFlowLayout().then {
        $0.sectionInset = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)
        $0.minimumLineSpacing = 5
        $0.minimumInteritemSpacing = 1
    }
    
//    public var collectionView = UICollectionView()
    
    // MARK: - Initialize
    public override init(frame: CGRect) {
        super.init(frame: frame)
        codeBaseInitializer()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Adding to ViewLayer
    //뷰가 다른 뷰의 서브뷰로 추가되기 직전에 호출됩니다.
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    // 뷰가 다른 뷰의 서브뷰로 추가된 후에 호출됩니다.
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    // 뷰가 윈도우의 일부가 된 후에 호출됩니다
    public override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
    // MARK: - Layout Chnages
    // layoutSubviews: 뷰의 레이아웃이 필요할 때 호출됩니다. 서브뷰의 크기와 위치를 조정하기에 적합한 메서드입니다.
    public override func layoutSubviews() {
        super.layoutSubviews()
        // 기본 height 설정해주기
//        self.bounds.size.height = 800
        self.backgroundColor = .orange
        
        
        self.flex.layout()
    }
    
    func layout() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayer)
        collectionView.backgroundColor = .yellow100
        
        self.flex.define { flex in
            flex.addItem(themeTitleLabel).width(100%).height(23)
            flex.addItem(collectionView).width(100%).height(210)
        }
    }
    /// setNeedsLayout: 뷰에 레이아웃 업데이트가 필요하다고 시스템에 알릴 때 사용됩니다. 이 메서드를 호출하면 시스템은 다음 업데이트 주기에서 layoutSubviews를 호출합니다.
    /// layoutIfNeeded: 현재의 레이아웃 업데이트가 필요한 경우 "즉시" 레이아웃을 업데이트합니다.
}
