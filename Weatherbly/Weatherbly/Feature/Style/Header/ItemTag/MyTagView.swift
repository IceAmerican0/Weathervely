//
//  MyTagView.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/1/24.
//

import Foundation
import UIKit

class MyTagView: UIView {
    
    public var selectChanged: ((MyTagView) ->())?
    public var tagLabel = LabelMaker(
        font: UIFont.body_5_B,
        fontColor: .black,
        alignment: .center
    ).make(text: "#Item1")
    
    public var text: String = "" {
        didSet {
            tagLabel.text = text
        }
    }
    
    // color
    public var normalForegroundColor: UIColor = UIColor(red: 78.0 / 255.0, green: 164.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
    public var normalBackgroundColor: UIColor = .white
    public var highlightForegroundColor: UIColor = .lightGray
    public var highlightBackgroundColor: UIColor = UIColor(red: 78.0 / 255.0, green: 164.0 / 255.0, blue: 145.0 / 255.0, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func commonInit() -> Void {
        backgroundColor = normalBackgroundColor
        tagLabel.textColor = normalForegroundColor
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tagLabel)
        let g = self
        NSLayoutConstraint.activate([
            tagLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 4.0),
            tagLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 8.0),
            tagLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -8.0),
            tagLabel.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -4.0),
            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40.0),
        ])
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray20.cgColor
        
        let t = UITapGestureRecognizer(target: self, action: #selector(gotTap(_:)))
        addGestureRecognizer(t)
    }
    @objc func gotTap(_ sender: Any?) {
        selected.toggle()
        selectChanged?(self)
    }
    
    var selected: Bool = false {
        didSet {
            if selected {
                backgroundColor = normalForegroundColor
                tagLabel.textColor = normalBackgroundColor
                layer.borderColor = normalBackgroundColor.cgColor
            } else {
                backgroundColor = normalBackgroundColor
                tagLabel.textColor = normalForegroundColor
                layer.borderColor = normalForegroundColor.cgColor
            }
        }
    }
}
