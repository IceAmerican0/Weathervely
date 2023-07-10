//
//  DailyForecastTableViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/07.
//

import UIKit
import PinLayout

class DailyForecastTableViewCell: UITableViewCell {
    
    let dateView = UIView()
    var keyLabel = CSLabel(.regular, 20, "")
    var valueLabel = CSLabel(.regular, 36, "")
    
    let logoImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        contentView.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(dateView).marginLeft(36).height(100).define { flex in
                flex.addItem(keyLabel).marginTop(13).height(16)
                flex.addItem(valueLabel).marginTop(15).height(10)
            }
            flex.addItem(logoImageView).size(50)
        }
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
}
