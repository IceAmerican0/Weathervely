//
//  CSLabel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/16.
//

import UIKit

public final class CSLabel: UILabel {
    
    enum LabelStyle {
        case bold
        case regular
        case underline
    }
    
    private var labelStyle: LabelStyle
    private var labelFontSize: CGFloat
    private var labelText: String
    private var labelColor: CSColor
    
    init(_ labelStyle: LabelStyle,
         _ labelFontSize: CGFloat,
         _ labelText: String,
         _ labelColor: CSColor
    ) {
        self.labelStyle = labelStyle
        self.labelFontSize = labelFontSize
        self.labelText = labelText
        self.labelColor = labelColor
        super.init(frame: .zero)
        setLabelStyle()
    }
    
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
        self.labelColor = .none
        super.init(frame: .zero)
        setLabelStyle()
        self.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelStyle() {
        self.do {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.textColor = .black
            
            switch labelStyle {
            case .bold:
                $0.attributedText = NSMutableAttributedString().bold(labelText, labelFontSize, labelColor)
            case .regular:
                $0.attributedText = NSMutableAttributedString().regular(labelText, labelFontSize, labelColor)
            case .underline:
                $0.attributedText = NSMutableAttributedString().underLine(labelText, labelFontSize, labelColor)
            }
        }
    }
}
