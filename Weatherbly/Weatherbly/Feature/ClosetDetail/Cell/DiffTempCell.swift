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
    
    private var imageView = UIImageView().then {
        $0.image = UIImage.image_indicator.resized(to: CGSize(width: 56, height: 56))
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
        layout()
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.direction(.column).define {
            $0.addItem(imageViewWrapper).define {
                $0.addItem(imageView).width(120).height(180).alignSelf(.center)
            }
        }
    }
    
    func configure(info : RowInfo?) {
        guard let info = info else { return }
        let id = info.closetId
        let imageUrl = info.closetImageUrl
        let name = info.closetName
        let status = info.closetStatus
        
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
        self.imageView.image = nil
    }
}


