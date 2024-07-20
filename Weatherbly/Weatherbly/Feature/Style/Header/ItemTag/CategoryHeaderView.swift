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
    
    private var bag = DisposeBag()
    public var headerDelegate: CategoryHeaderViewDelegate?
    public var typeInfo = ClosetTypeInfo.init(id: 0, name: "")
    private var sectionTitleLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "#Type1")
    
//    var typeTitleRelay = BehaviorRelay<MCategoryInfo?>(value: MCategoryInfo(id: 1, name: "initial value"))
    private var categoriesRelay = BehaviorRelay<[MCategoryInfo]>(value: [
        MCategoryInfo(id: 28, name: "니트/스웨터"),
        MCategoryInfo(id: 31, name: "긴소매 티셔츠"),
        MCategoryInfo(id: 32, name: "셔츠/블라우스"),
        MCategoryInfo(id: 33, name: "피케/카라티셔츠"),
        MCategoryInfo(id: 34, name: "반소매 티셔츠"),
        MCategoryInfo(id: 35, name: "민소매 티셔츠"),
        MCategoryInfo(id: 37, name: "기타 상의")
    ])
    private var itemTagHeaderWrapper = UIStackView()
    private var tagsView: CategoryTagsView? // 태그 뷰를 캐싱
    
    // selectedTags 상태를 관리
    public var selectedTags = BehaviorRelay<[Int]>(value: [])
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        binding()
        snapKitLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sectionTitleLabel.text = ""
        categoriesRelay.accept([])
        tagsView?.tags = []  // 태그 뷰 초기화
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews(sectionTitleLabel, itemTagHeaderWrapper)
        
        tagsView = CategoryTagsView(mockType: .a)
        tagsView?.backgroundColor = .white
        tagsView?.numRows = 2
        tagsView?.tagsDelegate = self
        if let tagsView = tagsView {
            itemTagHeaderWrapper.addSubview(tagsView)
        }
    }
    
    func snapKitLayout() {
        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        itemTagHeaderWrapper.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        tagsView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateTags(_ tags: [MCategoryInfo]) {
        tagsView?.tags = tags
    }
    
    func binding() {
        categoriesRelay
            .asDriver()
            .drive(with: self, onNext: { owner, tags in
                owner.updateTags(tags)
            }).disposed(by: bag)
        
        selectedTags
            .asDriver()
            .drive(with: self, onNext: { owner, tags in
                owner.tagsView?.selectedTags.accept(tags)
            }).disposed(by: bag)
    }
    
    func configure(info: ClosetTypeInfo?, categories: [MCategoryInfo]?) {
        print("Header view Configure")
        guard let typeInfo = info else { return }
        self.typeInfo = typeInfo
        sectionTitleLabel.text = "#\(typeInfo.name)"
        
        guard let categories = categories else { return }
        categoriesRelay.accept(categories.map { $0 })
    }
}

extension CategoryHeaderView: ItemTagViewDelegate {
    func selectItemTags(view: CategoryTagsView, with tags: [Int]) {
        guard let mockType = view.mockType else { return }
        switch mockType {
        case .a:
            print()
        case .b:
            print()
        
        }
    }
    
    func selectItemTags(with tags: [Int]) {
            debugPrint("아니 씨발 이거 뭔데? \(tags)")
            selectedTags.accept(tags)  // selectedTags를 업데이트
            headerDelegate?.sendCategoryWithType(self, tags: selectedTags.value, typeInfo: self.typeInfo)
    }
    
}
