//
//  DiffTempCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/10/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxGesture
import RxCocoa
import Kingfisher

final class DiffTempCell: UICollectionViewCell {
    var bag = DisposeBag()
    
    let imagePlaceHolder = UIImage.image_indicator
    
    private var imageViewWrapper = UIView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var imageView = UIImageView().then {
        $0.image = UIImage.image_indicator.resized(to: CGSize(width: 56, height: 56))
        $0.contentMode = .scaleAspectFit
    }
    
    public var itemTap: Driver<Void> {
        imageView.rx.tapGesture().when(.ended).map { _ in }.asDriver(onErrorJustReturn: ())
    }
    
    private var id = ""
    private var closetName = ""
    private var imageUrl = ""
    private var status = ""
    
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
        
        imageView.layer.masksToBounds = true
        imageView.setCornerRadius(12)
        
        contentView.flex.direction(.column).define {
            $0.addItem(imageViewWrapper).define {
                $0.addItem(imageView).width(120).height(180).alignSelf(.center)
            }
        }
    }
    
    func configure(info : RowInfo?) {
        guard let info = info else { return }
        let imageUrl = info.closetImageUrl
        
        imageView.setKF(urlString: imageUrl, placeHolder: UIImage.image_indicator) { [weak self] result in
            switch result {
            case .success:
                self?.imageView.pin.all()
                self?.imageView.contentMode = .scaleAspectFit
            case .failure:
                self?.imageView.pin.center().size(56)
                self?.imageView.contentMode = .center
            }
            self?.updateLayout(self?.imageView)
        }
    }
    
    private func updateLayout(_ view: UIView?) {
//        view!.flex.markDirty()
        view!.layoutIfNeeded()
        view!.setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        self.imageView.image = nil
        self.imageView.kf.cancelDownloadTask()
    }
}


