//
//  MultipleRowTagViewTests.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/1/24.
//

import Foundation
import UIKit

class MyTagsVC: UIViewController, MyTagsViewDelegate, ItemTagsHeaderDelegate {
    
    let theTags: [String] = [
        "#니트/스웨터", "#후드 티셔츠", "#맨투맨/스웨트셔츠", "#긴소매 티셔츠", "#셔츠/블라우스","#피케/카라 티셔츠", "#반소매 티셔츠",
                                 "민소매 티셔츠","기타 상의","후드 집업","블루종/MA-1","레더/라이더스 재킷","무스탕/퍼","트러커 재킷","슈트/블레이저 재킷","카디건","아노락 재킷","플리스/뽀글이","스타디움 재킷","겨울 싱글 코트","겨울 더블 코트","겨울 기타 코트","숏패딩/숏헤비 아우터","패딩 베스트","베스트","사파리/헌팅 재킷","나일론/코치 재킷"
    ]
    
    let stack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: g.topAnchor, constant: 0),
            stack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0),
            // let the view determine its own height
        ])
        
            let tv = ItemTagsHeaderView()
            tv.backgroundColor = .white
            tv.numRows = 2
            tv.tags = self.theTags
            tv.delegate = self
            stack.addArrangedSubview(tv)
        
    }
    
    // MARK: - ItemTagHeaderView 사용
    
    func itemTagView(_ itemTagView: ItemTagsHeaderView, didSelectItemAt index: Int) {
        guard let tvIDX = stack.arrangedSubviews.firstIndex(of: itemTagView) else { return }
        print("Selected: \(index) / \"\(theTags[index])\" in tags view \(tvIDX)")
    }
    
    func itemTagView(_ itemTagView: ItemTagsHeaderView, didDeSelectItemAt index: Int) {
        guard let tvIDX = stack.arrangedSubviews.firstIndex(of: itemTagView) else { return }
        print("Deselected: \(index) / \"\(theTags[index])\" in tags view \(tvIDX)")
        
    }
    
    
    
    
    // MARK: - Test용 MyTagView
        func itemTagView(_ itemTagView: MyTagsView, didSelectItemAt index: Int) {
            guard let tvIDX = stack.arrangedSubviews.firstIndex(of: itemTagView) else { return }
            print("Selected: \(index) / \"\(theTags[index])\" in tags view \(tvIDX)")
        }
    
        func itemTagView(_ itemTagView: MyTagsView, didDeSelectItemAt index: Int) {
            guard let tvIDX = stack.arrangedSubviews.firstIndex(of: itemTagView) else { return }
            print("Deselected: \(index) / \"\(theTags[index])\" in tags view \(tvIDX)")
        }
}
