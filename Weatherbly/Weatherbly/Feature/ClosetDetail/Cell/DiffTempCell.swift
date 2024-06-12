//
//  DiffTempCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/10/24.
//

import UIKit
import FlexLayout
import PinLayout

final class DiffTempCell: UICollectionViewCell {
    
    let imagePlaceHolder = UIImage.image_indicator
    
    private var imageViewWrapper = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private var closetImageView = UIImageView().then {
        $0.image = UIImage.image_indicator
        $0.contentMode = .scaleAspectFit
    }
    
    private var id = ""
    private var closetName = ""
    private var imageUrl = ""
    private var status = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.direction(.column).define {
            $0.addItem(imageViewWrapper).backgroundColor(UIColor.gray10).define {
                $0.addItem(closetImageView).height(180).alignSelf(.center)
            }
        }
    }
}


