//
//  UnderlineTitleSegmentView.swift
//  Weatherbly
//
//  Created by Khai on 1/15/24.
//

import UIKit
import Then

final class UnderlineTitleSegmentView: UISegmentedControl {
    
    private lazy var underline = UIView().then {
        let width = bounds.size.width / CGFloat(numberOfSegments)
        let height = 2.0
        let xCoordinate = CGFloat(selectedSegmentIndex * Int(width))
        let yCoordinate = bounds.size.height
        let frame = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
        let view = UIView(frame: frame)
        $0.backgroundColor = .gray600
        $0.setCornerRadius(1)
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefault()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        setDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(underline)
        
        let xCoordinate = (bounds.width / CGFloat(numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(
          withDuration: 0.1,
          animations: {
              self.underline.frame.origin.x = xCoordinate
          }
        )
    }
    
    private func setDefault() {
        let image = UIImage()
        
        /// 배경 제거
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        /// 구분선 제거
        setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}
