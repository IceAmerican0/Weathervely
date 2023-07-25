//
//  EditRegionTableViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/25.
//

import Foundation
import FlexLayout
import PinLayout
import Then

public final class EditRegionTableViewCell: UITableViewCell {
    
    public var regionLabel = CSLabel(.regular, 20, "")
    public let cancelButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    private func layout() {
        contentView.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(regionLabel).marginTop(13).height(16)
            flex.addItem(cancelButton).size(45)
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
