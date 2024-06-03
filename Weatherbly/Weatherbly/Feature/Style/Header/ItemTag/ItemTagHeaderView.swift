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

// protocol so we can tell the controller about selections
protocol ItemTagsHeaderDelegate {
    func itemTagView(_ itemTagView: ItemTagsHeaderView, didSelectItemAt index: Int)
    func itemTagView(_ itemTagView: ItemTagsHeaderView, didDeSelectItemAt index: Int)
}

final class ItemTagsHeaderView: UIView  {
    
    public var delegate: ItemTagsHeaderDelegate?
    var bag = DisposeBag()
    
    public var tagsRelay = BehaviorRelay<[String]>(value: [])
    public let tags = ["#니트/스웨터", "#후드 티셔츠", "#맨투맨/스웨트셔츠", "#긴소매 티셔츠", "#셔츠/블라우스","#피케/카라 티셔츠", "#반소매 티셔츠",
                       "민소매 티셔츠","기타 상의","후드 집업","블루종/MA-1","레더/라이더스 재킷","무스탕/퍼","트러커 재킷","슈트/블레이저 재킷","카디건","아노락 재킷","플리스/뽀글이","스타디움 재킷","겨울 싱글 코트","겨울 더블 코트","겨울 기타 코트","숏패딩/숏헤비 아우터","패딩 베스트","베스트","사파리/헌팅 재킷","나일론/코치 재킷"]
    var tagViews: [ItemTagView] = []
    public var theTags: [String] = [] {
        didSet {
            vStack.arrangedSubviews.forEach { v in
                v.removeFromSuperview()
            }
            tagViews = []
            var totalWidth: CGFloat = 0
            theTags.forEach{ str in
                let t = ItemTagView()
                t.tagLabel.text = str
                let size = t.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                totalWidth += size.width
                tagViews.append(t)
            }
            
            let rowWidth: CGFloat = totalWidth / CGFloat(numRows)
            var iTag: Int = 0
            while iTag < tagViews.count {
                let v = UIStackView().then {
                    $0.spacing = 8
                }
                vStack.addArrangedSubview(v)
                var cw: CGFloat = 0
                while cw < rowWidth, iTag < tagViews.count {
                    let t = tagViews[iTag]
                    let size = t.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    v.addArrangedSubview(t)
                    cw += size.width
                    iTag += 1
                }
            }
            
            // set closure so we can track selections
//            tagViews.forEach { tv in
//                tv.stateChangeRealy.subscribe(onNext: { [weak self] theTagView in
//                    
//                    guard let self = self,
//                          let index = self.tagViews.firstIndex(of: theTagView) else { return }
//                    
//                    if theTagView.selectedState == .selected {
//                        self.delegate?.itemTagView(self, didSelectItemAt: index)
//                    } else {
//                        self.delegate?.itemTagView(self, didDeSelectItemAt: index)
//                    }
//                }).disposed(by: bag)
            
            
//                tv.stateChangeRealy = { [weak self] theTagView in
//                    guard let self = self,
//                    let index = self.tagViews.firstIndex(of: theTagView) else { return }
//                    
//                    if theTagView.state {
//                        self.itemTagDelegate?.myTagsView(self, didSelectItemAt: index)
//                    } else {
//                        self.itemTagDelegate?.myTagsView(self, didDeSelectItemAt: index)
//                    }
//                }
//            }
        }
    }
    
    var numRows = 2
    let vStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func commonInit() -> Void {
        let scrollView = UIScrollView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addSubview(vStack)
        }
        addSubviews(scrollView)
        
        let g = self
        let cg = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
                   scrollView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
                   scrollView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
                   scrollView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
                   scrollView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
                   
                   vStack.topAnchor.constraint(equalTo: cg.topAnchor, constant: 8.0),
                   vStack.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 8.0),
                   vStack.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: -8.0),
                   vStack.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: -8.0),
                   
                   scrollView.heightAnchor.constraint(equalTo: vStack.heightAnchor, constant: 16.0),
               ])
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        self.flex.layout()
    }
    
    func layout() {
//        self.flex.addItem(tagCollectionView).width(100%).height(66).direction(.row)
        
        let scrollView = UIScrollView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addSubview(vStack)
        }
//        addSubviews(scrollView)
        
        self.flex.addItem(scrollView).define {
            $0.addItem(vStack).width(100%).height(100%)
        }
//        let g = self
//        let cg = scrollView.contentLayoutGuide
//        NSLayoutConstraint.activate([
//                   scrollView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
//                   scrollView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
//                   scrollView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
//                   scrollView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
//                   
//                   vStack.topAnchor.constraint(equalTo: cg.topAnchor, constant: 8.0),
//                   vStack.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 8.0),
//                   vStack.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: -8.0),
//                   vStack.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: -8.0),
//                   
//                   scrollView.heightAnchor.constraint(equalTo: vStack.heightAnchor, constant: 16.0),
//               ])
        
    }
    
//    func configure() {
//        tagsRelay.accept(tags)
//    }
}

