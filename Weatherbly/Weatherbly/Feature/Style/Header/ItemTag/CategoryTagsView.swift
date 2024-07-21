//
//  ItemTagHeaderView.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

enum MockType {
    case a
    case b
}

protocol ItemTagsViewDelegate: AnyObject {
    func selectItemTags(view: CategoryTagsView, categoryInfo: MCategoryInfo)
}

final class CategoryTagsView: UIView {
    
    // MARK: - State
    public var typeInfo = ClosetTypeInfo.init(id: 0, name: "")
    public weak var tagsViewDelegate: ItemTagsViewDelegate?
    public var identifer: String?
    var bag = DisposeBag()
    
    private var sectionTitleLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "#Type1")
    

    var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)
    }
    public var numRows: Int = 2
    // vertical stack view to hold the rows
    private let vStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    public var selectedTags = BehaviorRelay<[Int]>(value: [])
    public var tagViews: [ItemTagView] = []
    
    var tags: [MCategoryInfo] = [] {
        didSet {
            // clear existing (in case we're setting the tags multiple times)
            vStack.arrangedSubviews.forEach { v in
                v.removeFromSuperview()
            }
            tagViews = []
            var totalWidth: CGFloat = 0
            // create individual tag views and get the total width
            tags.forEach { category in
                let t = ItemTagView()
                t.configure(with: category, selectedTags: selectedTags.value)
                t.tagDidTap.bind(with: self) { owner, event in
                    owner.tagsViewDelegate?.selectItemTags(view: owner, categoryInfo: t.categoryInfo)
                }.disposed(by: t.bag)
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
        }
    }
    
    func binding() {
        // FIXME: - 필요없으면 지우기
        selectedTags.asDriver()
            .drive(with: self) { owner, tags in
                
            }.disposed(by: bag)
        
    }
    
    init(identifier: String, typeInfo: ClosetTypeInfo) {
        super.init(frame: .zero)
        print("TagsView identifier : \(identifier)")
        print("TagsView typeInfo : \(typeInfo)")
        self.identifer = identifier
        self.typeInfo = typeInfo
        commonInit(typeInfo: typeInfo)
    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    
    func commonInit(typeInfo: ClosetTypeInfo) {
        // Pin 또는 Flex 사용할 경우 Layout 정상적으로 작동하지 않는다.
        // UIView의 라이프싸이클 문제로 추측 된다.
        addSubview(scrollView)
        scrollView.addSubview(vStack)
        
        
//        let g = self
        let cg = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
            
            vStack.topAnchor.constraint(equalTo: cg.topAnchor, constant: 0),
            vStack.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 0),
            vStack.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: 0),
            vStack.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: 0),
            
            scrollView.heightAnchor.constraint(equalTo: vStack.heightAnchor, constant: 0),
        ])
    }
    
    public func configure(info: ClosetTypeInfo?, categories: [MCategoryInfo]?) {
        guard let typeInfo = info else { return }
        sectionTitleLabel.text = "#\(typeInfo.name)"
    }
    
}

extension CategoryTagsView: ItemTagDelegate {
    func itemTagDidTap(categoryInfo: MCategoryInfo?) {
        guard let category = categoryInfo else { return }
        let id = category.id
        debugPrint("\n\nin CategoryTagsView: \(id)")
        
        // 태그뷰 모으기
        var tags = selectedTags.value
        // 중복제거
        if !tags.contains(id) {
            tags.append(id)
        } else {
            tags = tags.filter { $0 != id }
        }
        debugPrint("after accepted : \(tags)")
        selectedTags.accept(tags)
//        tagsViewDelegate?.selectItemTags(view: self, with: tags)
    }
}
