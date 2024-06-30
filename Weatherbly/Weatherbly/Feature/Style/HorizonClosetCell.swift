//
//  StyleClosetCell.swift
//  Weatherbly
//
//  Created by Khai on 10/18/23.
//  Fixed by 최수훈 on 2024/05/30

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift

final class HorizonClosetCell: UICollectionViewCell {
    
    var bag = DisposeBag()
    
    var imageViewWrapper = UIView().then {
        $0.layer.cornerRadius =  12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = true
    }
    lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = true
    }
    
    var nameLabel = LabelMaker(font: UIFont.body_5_M).make().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = UIColor.gray100
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
        // TODO: - layout의 위치가 어디가 더 적절할까?
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        
    }
    
    func cellLayout() {
        
        contentView.flex.height(209).define { flex in
            flex.addItem(imageViewWrapper).backgroundColor(UIColor.gray10).define {
                $0.addItem(imageView).height(180).alignSelf(.center)
            }
            flex.addItem(nameLabel).height(nameLabel.font.setLineHeight()).marginTop(12)
        }
        
        
    }
    
    func configureCell(_ info: StyleClosetInfo?) {
        guard let info = info else { return }
        
        nameLabel.text = info.name
        let placeHolder = UIImage.image_indicator
        // TODO: nameLabel Text -> Shop name
        
        imageView.setKF(urlString: info.imageUrl, placeHolder: placeHolder) { [weak self] result in
                   switch result {
                   case .success:
                       self?.imageView.pin.all()
                       self?.imageView.contentMode = .scaleAspectFit
                   case .failure:
                       self?.imageView.pin.all()
                       self?.imageView.contentMode = .center
                       self?.imageView.flex.alignSelf(.center)
                       self?.imageView.flex.layout()
                   }
                    // FlexLayout 레이아웃 업데이트
                    self?.imageView.flex.markDirty()
                    self?.imageView.setNeedsLayout()
                    self?.imageView.layoutIfNeeded()
               }
//        imageView.setKF(urlString: info.imageUrl, placeHolder: placeHolder) { result in
//            print("\n\n \(result)")
//        }
//        
//        // FlexLayout 레이아웃 업데이트
//        self.imageView.flex.markDirty()
//        self.imageView.setNeedsLayout()
//        self.imageView.layoutIfNeeded()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = nil
//        self.imageView.flex.markDirty()
//        self.imageView.setNeedsLayout()
//        self.imageView.layoutIfNeeded()
//    }
    
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.bag = DisposeBag()
//        contentView.removeFromSuperview()
//        imageView.removeFromSuperview()
//        nameLabel.removeFromSuperview()
//        
//    }

}
