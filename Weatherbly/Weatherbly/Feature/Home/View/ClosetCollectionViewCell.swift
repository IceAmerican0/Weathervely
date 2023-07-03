//
//  ClosetCollectionViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/29.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class ClosetCollectionViewCell: UICollectionViewCell {
    
    private var clothImageView = UIImageView()
    private var clothImageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
    private let clothImageHeight = UIScreen.main.bounds.height * 0.38
    private let clothImageWidth = UIScreen.main.bounds.width * 0.38
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    func attribute() {
        clothImageView.do {
            $0.image = UIImage(systemName: "gear")
        }
    }
    
    private func layout() {
        contentView.flex.alignSelf(.center).define { flex in
            flex.addItem(clothImageView).marginTop(13).width(clothImageWidth).height(clothImageHeight)
            flex.addItem(clothImageSourceLabel).marginTop(8).height(14)
        }
    }
    
}
