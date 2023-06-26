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
        case bold
        case regular
        case underline
    }
    
    private var labelStyle: LabelStyle
    private var labelText: String
    private var labelFontSize: CGFloat
    
    // MARK: - Initializer
    init(_ labelStyle: LabelStyle,
         labelText: String,
         labelFontSize: CGFloat
    ) {
        self.labelStyle = labelStyle
        self.labelText = labelText
        self.labelFontSize = labelFontSize
        super.init(frame: .zero)
        codeBaseInitializer()
    }
    
    convenience init(_ labelStyle: LabelStyle) {
        self.init(labelStyle, labelText: "", labelFontSize: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        setLabelStyle()
    }
    
    func setLabelStyle() {
        self.do {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            
            switch labelStyle {
            case .bold:
                $0.attributedText = NSMutableAttributedString().bold(string: labelText, fontSize: labelFontSize)
            case .regular:
                $0.attributedText = NSMutableAttributedString().regular(string: labelText, fontSize: labelFontSize)
            case .underline:
                $0.attributedText = NSMutableAttributedString().underLine(string: labelText)
            }
        }
    }
}
