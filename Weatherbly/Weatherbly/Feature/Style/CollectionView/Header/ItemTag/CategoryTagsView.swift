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

    public let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceHorizontal = true
        $0.delaysContentTouches = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
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
        flex.addItem(scrollView).marginLeft(20).grow(1).define {
            $0.addItem(firstRow).direction(.row).grow(1)
            $0.addItem(secondRow).direction(.row).marginTop(8).grow(1)
        }
    }
    
    public func configure(tags: [StyleMediumCategoryInfo]? = nil, selectedTags: [Int]) {
        self.selectedTags = selectedTags
        
        guard let tags else { return }
        
        var index = 0
        var firstWidth = 0.0
        var secondWidth = 0.0
        
        tags.forEach { category in
//            let tagView = ItemTagView()
//            tagView.configure(with: category, selectedTags: selectedTags)
//            tagView.tagDidTap
//                .asDriver(onErrorJustReturn: UITapGestureRecognizer())
//                .drive(with: self) { owner, event in
//                if tagView.selectedState.value == .selected { tagView.selectedState.accept(.deSelected) } else {
//                    tagView.selectedState.accept(.selected)
//                }
//                owner.tagsViewDelegate?.selectItemTags(categoryInfo: tagView.categoryInfo)
//                
//            }.disposed(by: tagView.bag)
            
            let tagView = FilterButton(filterType: .style).then {
                $0.titleLabel?.numberOfLines = 1
                $0.titleLabel?.adjustsFontSizeToFitWidth = true
                $0.titleAttribute(title: category.name)
                
                if selectedTags.contains(category.id) {
                    $0.isSelected = true
                } else {
                    $0.isSelected = false
                }
                $0.flex.markDirty()
            }
            
            tagView.rx.tap.asDriver()
                .drive(with: self) { owner, _ in
                    owner.tagsViewDelegate?.selectItemTags(categoryInfo: category)
                    tagView.isSelected.toggle()
                }.disposed(by: bag)
            
            if (tags.count / 2) > index {
                firstRow.flex.addItem(tagView).marginRight(8)
                firstRow.flex.markDirty()
                firstWidth += tagView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).width + 8
            } else {
                secondRow.flex.addItem(tagView).marginRight(8)
                secondRow.flex.markDirty()
                secondWidth += tagView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).width + 8
            }
            
            index += 1
        }
        
        maxWidth = max(firstWidth, secondWidth)
        
        scrollView.flex.layout()
    }
}

extension CategoryTagsView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.flex.layout()
    }
}
