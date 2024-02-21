//
//  NewCSLabel.swift
//  Weatherbly
//
//  Created by 최수훈 on 12/24/23.
//

import UIKit

public final class NewCSLabel: UILabel {
    private let paragraphStyle = NSMutableParagraphStyle()
    var padding: UIEdgeInsets = .zero
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    override public var lineBreakMode: NSLineBreakMode {
        didSet {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            paragraphStyle.alignment = textAlignment
        }
    }
    
    var lineHeight: CGFloat = 1 {
        didSet {
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.minimumLineHeight = lineHeight
        }
    }
}

public enum AttributedText {
    /// 기존 텍스트, 커스텀할 텍스트, 커스텀할 내용(폰트, 컬러, 밑줄 등)
    case custom(originText: String, targetText: String, attributes: [NSAttributedString.Key: Any])
    
    public var setAttribute: NSAttributedString {
        switch self {
        case .custom(let originText, let targetText, let attributes):
            let attributed = NSMutableAttributedString(string: originText)
            let range = (originText as NSString).range(of: targetText)
            attributed.addAttributes(attributes, range: range)
            return attributed
        }
    }
}

public struct LabelMaker: LabelDesign {
    public var font: UIFont
    public var fontColor: UIColor
    public var alignment: NSTextAlignment
    public var padding: UIEdgeInsets
    
    public init(
        font: UIFont,
        fontColor: UIColor = .black,
        alignment: NSTextAlignment = .left,
        padding: UIEdgeInsets = .zero
    ) {
        self.font = font
        self.fontColor = fontColor
        self.alignment = alignment
        self.padding = padding
    }
}

public protocol LabelDesign {
    var font: UIFont { get }
    var fontColor: UIColor { get }
    var alignment: NSTextAlignment { get }
    var padding: UIEdgeInsets { get }
}

public extension LabelDesign {
    func make(
        text: String? = nil,
        attributed: AttributedText? = nil
    ) -> NewCSLabel {
        return NewCSLabel(padding: padding).then {
            $0.numberOfLines = 0
            $0.lineHeight = font.lineHeight
            $0.textAlignment = alignment
            $0.font = font
            $0.textColor = fontColor
            $0.text = text
        }
    }
}
