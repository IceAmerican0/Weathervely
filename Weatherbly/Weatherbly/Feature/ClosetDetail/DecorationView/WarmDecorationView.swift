//
//  DiffTempDecorationView.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/23/24.
//

import UIKit

final class WarmDecorationView: UICollectionReusableView {
    
    private let decoWrapper = UIView()
    private let bgImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage.moreHot_banner
    }
    private let tempIconImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage.moreHot_illust
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(decoWrapper)
        decoWrapper.addSubviews(bgImage, tempIconImage)
        
        decoWrapper.pin.all()
        bgImage.pin.top().horizontally().height(160)
        tempIconImage.pin.size(49).top(31).right(20)
    }
 
}
