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
import Then

public protocol ItemTagsViewDelegate: AnyObject {
    func selectItemTags(categoryInfo: StyleMediumCategoryInfo)
}

public final class CategoryTagsView: UIView {
    
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

    private let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
        $0.delaysContentTouches = false
    }
    
    private let firstRow = UIView()
    
    private let secondRow = UIView()
    
    private var maxWidth = 0.0
    
    public var selectedTags: [Int] = []
    
    var tags: [StyleMediumCategoryInfo] = []
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.pin.all()
        scrollView.flex.layout()
        
        scrollView.contentSize = CGSize(
            width: maxWidth,
            height: scrollView.frame.height
        )
    }
    
    func layout() {
        flex.addItem(scrollView).marginLeft(12).marginRight(20).grow(1).define {
            $0.addItem(firstRow).direction(.row).grow(1)
            $0.addItem(secondRow).direction(.row).marginTop(8).grow(1)
        }
    }
    
    public func configure(tags: [StyleMediumCategoryInfo]? = nil, selectedTags: [Int]) {
        self.selectedTags = selectedTags
        
        guard let tags = tags else { return }
        
        var index = 0
        var firstWidth = 0.0
        var secondWidth = 0.0
        
        tags.forEach { category in
            let tagView = ItemTagView()
            tagView.configure(with: category, selectedTags: selectedTags)
            tagView.tagDidTap
                .asDriver(onErrorJustReturn: UITapGestureRecognizer())
                .drive(with: self) { owner, event in
                if tagView.selectedState.value == .selected { tagView.selectedState.accept(.deSelected) } else {
                    tagView.selectedState.accept(.selected)
                }
                owner.tagsViewDelegate?.selectItemTags(categoryInfo: tagView.categoryInfo)
                
            }.disposed(by: tagView.bag)
            
            if (tags.count / 2) > index {
                firstRow.flex.addItem(tagView).marginLeft(8)
                firstRow.flex.markDirty()
                firstWidth += tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
            } else {
                secondRow.flex.addItem(tagView).marginLeft(8)
                secondRow.flex.markDirty()
                secondWidth += tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
            }
            
            index += 1
        }
        
        if firstWidth > secondWidth {
            maxWidth = firstWidth
        } else {
            maxWidth = secondWidth
        }
        
        scrollView.flex.layout()
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension CategoryTagsView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
