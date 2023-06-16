//
//  CSLabel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/16.
//

import UIKit

class CSLabel: UILabel, CodeBaseInitializerProtocol {
    
    // MARK: - Control Property
    
    enum LabelStyle {
        case primary
        case custom
    }
    
    private var labelStyle: LabelStyle
    // MARK: - Initializer
    
    init(_ labelStyle: LabelStyle) {
        self.labelStyle = labelStyle
        super.init(frame: .zero)
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func attribute() {
        setLabelStyle(labelStyle)
    }
    
    func setLabelStyle(_ style: LabelStyle) {
        
        labelStyle = style
        
        switch style {
            case .primary:
                
                self.do {
                    $0.numberOfLines = 0
                    $0.textAlignment = .center
                    $0.font = .boldSystemFont(ofSize: 25)
                }
            
            case .custom:
                
                self.do {
                    $0.text = ""
                }
        }
    }
}
