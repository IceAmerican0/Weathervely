//
//  MyTagsView.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/1/24.
//

import Foundation
import UIKit

// protocol so we can tell the controller about selections
protocol MyTagsViewDelegate {
    func itemTagView(_ itemTagView: MyTagsView, didSelectItemAt index: Int)
    func itemTagView(_ itemTagView: MyTagsView, didDeSelectItemAt index: Int)
}

class MyTagsView: UIView {

    public var delegate: MyTagsViewDelegate?
    
    // number of rows of tagViews
    public var numRows: Int = 2
    
    // vertical stack view to hold the rows
    private let vStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public var tagViews: [ItemTagView] = []
//        public var tagViews: [MyTagView] = []
    
    var theTags: [String] = [] {
        didSet {
            // clear existing (in case we're setting the tags multiple times)
            vStack.arrangedSubviews.forEach { v in
                v.removeFromSuperview()
            }
            tagViews = []
            var totalWidth: CGFloat = 0
            // create individual tag views and get the total width
            theTags.forEach { str in
//                let t = MyTagView()
                let t = ItemTagView()
//                t.text = str
                t.tagLabel.text = str
                let sz = t.labelWrapper.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                totalWidth += sz.width + 28
                tagViews.append(t)
            }
 
            let rowWidth: CGFloat = totalWidth / CGFloat(numRows)
            var iTag: Int = 0
            while iTag < tagViews.count {
                // create a new "row" horizontal stack view
                let v = UIStackView()
                v.spacing = 8
                vStack.addArrangedSubview(v)
                var currentRowWidth: CGFloat = 0
                // add tag views
                while currentRowWidth < rowWidth, iTag < tagViews.count {
                    let t = tagViews[iTag]
                    let sz = t.labelWrapper.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    v.addArrangedSubview(t)
                    currentRowWidth += sz.width + 28
                    iTag += 1
                }
            }

            // set closure so we can track selections
//            tagViews.forEach { tv in
//                tv.state = { [weak self] selectedState in
//                    guard let self = self,
//                    else { return }
//                    if selectedState.selected {
//                        self.delegate?.itemTa(self, didSelectItemAt: idx)
//                    } 
//                    else {
//                        self.delegate?.myTagsView(self, didDeSelectItemAt: idx)
//                    }
//                }
//            }
        }
    }
    
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func commonInit() -> Void {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(vStack)
        addSubview(scrollView)
        
        let g = self
        let cg = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
            scrollView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
            scrollView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
            scrollView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
            
            vStack.topAnchor.constraint(equalTo: cg.topAnchor, constant: 0),
            vStack.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 0),
            vStack.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: 0),
            vStack.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: 0),
            
            scrollView.heightAnchor.constraint(equalTo: vStack.heightAnchor, constant: 0),
        ])
    }
    
}

