//
//  CSLabel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/16.
//

import UIKit

public final class CSLabel: UILabel, CodeBaseInitializerProtocol {
    
    enum LabelStyle {
        case bold
        case regular
        case underline
    }
    
    private var labelStyle: LabelStyle
    private var labelText: String
    private var labelFontSize: CGFloat
    
    init(_ labelStyle: LabelStyle,
         _ labelFontSize: CGFloat,
         _ labelText: String
    ) {
        self.labelStyle = labelStyle
        if UIScreen.main.bounds.width < 376 {
            self.labelFontSize = labelFontSize - 4
        } else {
            self.labelFontSize = labelFontSize
        }
        self.labelText = labelText
        super.init(frame: .zero)
        codeBaseInitializer()
    }
    
    convenience init(_ labelStyle: LabelStyle) {
        self.init(labelStyle, 10, "")
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
            $0.textColor = .black
            
            switch labelStyle {
            case .bold:
                $0.attributedText = NSMutableAttributedString().bold(labelText, labelFontSize)
            case .regular:
                $0.attributedText = NSMutableAttributedString().regular(labelText, labelFontSize)
            case .underline:
                $0.attributedText = NSMutableAttributedString().underLine(labelText, labelFontSize)
            }
        }
    }
}
