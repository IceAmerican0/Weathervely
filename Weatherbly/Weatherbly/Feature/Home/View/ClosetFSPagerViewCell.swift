//
//  ClosetFSPagerViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/29.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import FSPagerView

final class ClosetFSPagerViewCell: FSPagerViewCell {
    
    var clothImageView = UIImageView()
    var clothImageSourceLabel = CSLabel(.regular, 11, "by 0000")
    
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
    
    private func layout() {
        contentView.flex.alignItems(.center).define { flex in
            flex.addItem(clothImageView).marginTop(13).width(clothImageWidth).height(clothImageHeight)
            flex.addItem(clothImageSourceLabel).marginTop(8).width(clothImageWidth).height(14)
        }
//        .shadow(color: .black.opacity(0.25), radius: 7.5, x: 0, y: 4)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 7.5
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
}
