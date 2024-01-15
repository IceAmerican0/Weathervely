//
//  UnderlineTitleSegmentCell.swift
//  Weatherbly
//
//  Created by Khai on 1/15/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

protocol UnderlineTitleSegmentCellDelegate: AnyObject {
    func selectCell(item: UnderlineTitleSegmentItem)
    func animateCell(frame: CGRect)
}

final class UnderlineTitleSegmentCell: UICollectionViewCell {
    weak var delegate: UnderlineTitleSegmentCellDelegate?
    private var cellState: UnderlineTitleSegmentItem?
    
    
}
