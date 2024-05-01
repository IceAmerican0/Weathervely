//
//  StyleClosetCell.swift
//  Weatherbly
//
//  Created by Khai on 10/18/23.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift

final class StyleClosetCell: UICollectionViewCell {
    
    var bag = DisposeBag()
    
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.tintColor = .green
    }
    
    var nameLabel = LabelMaker(font: UIFont.body_5_M).make().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    func cellLayout() {
        
        contentView.flex.width(120).height(209).define { flex in
            flex.addItem(imageView).height(180).justifyContent(.center)
            flex.addItem(nameLabel).height(nameLabel.font.setLineHeight()).marginTop(12)
        }
        
    }
    
    func configureCell(_ info: StyleClosetInfo?) {
        guard let info = info else { return }
        
        let placeHoleder = UIImage.image_indicator
        // TODO: nameLabel Text -> Shop name
        imageView.setKF(urlString: info.imageUrl, placeHolder: placeHoleder) { result in
            switch result {
            case .success(let value):
                print("success: \(value)")
            case .failure(let error):
                print("ERROR : \(result)")
            }
            
        }
//        imageView.flex.markDirty()

    }
    
    
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.bag = DisposeBag()
//        contentView.removeFromSuperview()
//        imageView.removeFromSuperview()
//        nameLabel.removeFromSuperview()
//        
//    }

}
