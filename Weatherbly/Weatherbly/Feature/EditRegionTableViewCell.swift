//
//  EditRegionTableViewCell.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/25.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift

public struct EditRegionCellState {
    let region: String
    let count: Int
}

public final class EditRegionTableViewCell: UITableViewCell {
    var buttonTapDisposable: Disposable?
    var cellIndex = 0
    
    public var regionLabel = LabelMaker(
        font: .body_1_M
    ).make().then {
        $0.lineBreakMode = .byTruncatingTail
    }
    
    public let button = NewCSButton(.compact, style: .violet600).then {
        $0.setTitle("편집", for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { dispose() }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        dispose()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.flex.layout()
    }
    
    func layout() {
        contentView.flex.direction(.row).alignItems(.center).justifyContent(.spaceBetween).define { flex in
            flex.addItem(regionLabel).marginLeft(20).height(21).grow(1)
            flex.addItem(button).marginHorizontal(20).width(53).height(24)
        }
        
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.violet150.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    func configureCellState(_ cellState: EditRegionCellState, _ index: Int) {
        cellIndex = index
        regionLabel.text = cellState.region
    }
    
    func buttonTapAction(completion: @escaping ((Int) -> Void)) {
        buttonTapDisposable = button.rx.tap
            .bind(with: self) { owner, _ in
                completion(owner.cellIndex)
            }
    }
    
    private func dispose() {
        if let disposable = buttonTapDisposable {
            disposable.dispose()
        }
    }
}
