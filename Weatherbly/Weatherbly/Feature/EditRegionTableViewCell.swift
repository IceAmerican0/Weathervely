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
import RxSwift

public struct EditRegionCellState {
    let region: String
    let isOnly: Bool
}

public final class EditRegionTableViewCell: UITableViewCell {
    
    public var regionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
        $0.numberOfLines = 0
    }
    public let button = UIButton().then {
        $0.setImage(AssetsImage.regionChange.image, for: .normal)
        $0.layer.cornerRadius = 5
    }
    
    public let labelWidth = UIScreen.main.bounds.width * 0.69
    
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
        contentView.flex.direction(.row).alignItems(.center).justifyContent(.center).define { flex in
            flex.addItem(regionLabel).marginLeft(23).width(labelWidth).height(28)
            flex.addItem(button).size(45)
        }
        
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    func configureCellState(_ cellState: EditRegionCellState) {
        regionLabel.text = cellState.region
        cellState.isOnly ? button.setImage(AssetsImage.regionChange.image, for: .normal) : button.setImage(AssetsImage.delete.image, for: .normal)
    }
}
