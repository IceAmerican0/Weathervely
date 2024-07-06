//
//  CategoryHeaderView.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/5/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class CategoryHeaderView : UICollectionReusableView {
    
    var bag = DisposeBag()
    /// 섹션 타이틀
    var sectionTitleLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "#Type1")
    
    /// 카테고리 테그뷰
    var typeTitleRelay = BehaviorRelay<MCategoryInfo?>(value: MCategoryInfo(id: 1,name:"initial value"))
    
    var itemTagHeaderWrapper = UIStackView()
    var theTags: [String] = [
        "겨울 기타 코트","숏패딩/숏헤비 아우터","패딩 베스트","베스트","사파리/헌팅 재킷","나일론/코치 재킷"]
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        binding()
        snapKitLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func snapKitLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews(sectionTitleLabel,
                         itemTagHeaderWrapper)
        
        // TagHeaderView
        let tagsView = CategoryTagsView()
        tagsView.backgroundColor = .white
        tagsView.numRows = 2
        tagsView.tags = self.theTags
        tagsView.delegate = self
        itemTagHeaderWrapper.addSubview(tagsView)
        
        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        itemTagHeaderWrapper.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        tagsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func binding() {
        typeTitleRelay
            .asDriver()
            .drive(with: self,
                   onNext: { owner, typeInfo in
                guard let tag = typeInfo else { return }
                owner.sectionTitleLabel.text = tag.name
            }).disposed(by: bag)
    }
    
    func configure(info: ClosetTypeInfo?, categories: [MCategoryInfo]?) {
        // TODO: - titleLabel 에 viewModel 의 값 넣기
        guard let info = info else { return }
        let typeID = info.id
        let typeNme = info.name
        sectionTitleLabel.text = "#\(typeNme)"
        
        // TODO: - tags에 실제 카테고리 값들 채워서 Layout 코드 다시 부르기
        guard let categories = categories else { return }
        theTags = categories.map { "#\($0.name)" }
        debugPrint("theTags : " , theTags)
        
    }
    
}

extension CategoryHeaderView: CategoryTagsViewDelegate {
    func itemTagView(_ itemTagView: CategoryTagsView, didSelectItemAt index: Int) {
        // TODO: - ViewControlelr 에 선택한 카테고리 아이디 알리기
        
    }
    
    func itemTagView(_ itemTagView: CategoryTagsView, didDeSelectItemAt index: Int) {
        // TODO: = ViewController 에 선택 해제 된 카테고리 아이디 알리기
    }
    
    
}
