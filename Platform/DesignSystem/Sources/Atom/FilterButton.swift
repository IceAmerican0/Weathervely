//
//  FilterButton.swift
//  Weatherbly
//
//  Created by Khai on 4/30/24.
//

import ResourcePackage
import UIKit
import Then

public enum FilterType {
    case style
    case item
}

public final class FilterButton: UIButton {
    
    public var filterType: FilterType
    
    var title: String?
    
    init(filterType: FilterType) {
        self.filterType = filterType
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isSelected: Bool {
        didSet {
            layout()
            titleAttribute(title: title)
        }
    }
    
    public func titleAttribute(title: String?) {
        self.title = title
        
        var titleFont: UIFont
        var titleColor: UIColor
        var selectedTitleColor: UIColor
        
        switch filterType {
        case .style:
            titleFont = UIFont.body_5_B
            titleColor = .black
            selectedTitleColor = .violet700
        case .item:
            titleFont = UIFont.body_1_B
            titleColor = .violet900
            selectedTitleColor = .white
        }
        
        var container = AttributeContainer()
        container.font = titleFont
        self.configuration?.attributedTitle = AttributedString(title ?? "", attributes: container)
        self.configuration?.baseForegroundColor = self.isSelected ? selectedTitleColor : titleColor
    }
}

extension FilterButton {
    private func layout() {
        var config = UIButton.Configuration.filled()
        
        switch filterType {
        case .style:
            config.contentInsets = NSDirectionalEdgeInsets.init(top: 6, leading: 14, bottom: 6, trailing: 14)
            config.background.strokeWidth = 1
            config.background.cornerRadius = 14
            config.baseBackgroundColor = self.isSelected ? .violet10 : .white
            config.background.strokeColor = self.isSelected ? .violet500 : .gray20
        case .item:
            config.contentInsets = NSDirectionalEdgeInsets.init(top: 8, leading: 14, bottom: 8, trailing: 14)
            config.background.strokeWidth = 2
            config.background.cornerRadius = 30
            config.baseBackgroundColor = self.isSelected ? .violet600 : .white
            config.background.strokeColor = self.isSelected ? .violet600 : .violet200
        }
        
        self.configuration = config
    }
}
