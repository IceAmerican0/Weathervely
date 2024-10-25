//
//  DiffTempCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/10/24.
//

import DesignSystem
import Network
import UIKit

final class DiffTempCell: UICollectionViewCell {
    var bag = DisposeBag()
    
    private var imageView = UIImageView().then {
        $0.contentMode = .center
        $0.layer.masksToBounds = true
        $0.setCornerRadius(12)
    }
    
    public var itemTap: Driver<Void> {
        imageView.rx.tapGesture().when(.ended).map { _ in }.asDriver(onErrorJustReturn: ())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
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
        clipsToBounds = true
        layer.masksToBounds = false
        layer.setShadow(
            CGSize(width: 4, height: 4),
            UIColor.dark12.cgColor, 1, 4
        )
        
        contentView.flex.define {
            $0.addItem(imageView).width(120).height(180).alignSelf(.center)
        }
    }
    
    func configure(info : RowInfo?) {
        guard let info = info else { return }
        let imageUrl = info.closetImageUrl
        
        imageView.setKF(urlString: imageUrl, placeHolder: UIImage.image_indicator) { [weak self] _ in
            guard let self else { return }
            self.layoutIfNeeded()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        self.imageView.image = nil
        self.imageView.kf.cancelDownloadTask()
    }
}


