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

protocol CategoryHeaderViewDelegate: AnyObject {
    func sendCategoryWithType(_ view: CategoryHeaderView, tags: [Int], typeInfo: ClosetTypeInfo)
}

final class CategoryHeaderView : UICollectionReusableView {
    
    private var bag = DisposeBag()
    public weak var headerDelegate: CategoryHeaderViewDelegate?
    public var typeInfo = ClosetTypeInfo.init(id: 0, name: "")
    private var sectionTitleLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "#Type1")
    
    var state: [Int] = []
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
        selectedTags = BehaviorRelay<[Int]>(value: [])
//        selectedTags.accept([])
//        categoriesRelay = BehaviorRelay<[MCategoryInfo]>(value: [])
        tagsView?.tags = []  // 태그 뷰 초기화
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews(sectionTitleLabel, itemTagHeaderWrapper)
        
        tagsView = CategoryTagsView(state)
        tagsView?.backgroundColor = .white
        tagsView?.numRows = 2
        tagsView?.configure(selectedTags.value)
        tagsView?.tagsViewDelegate = self
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
        tagsView?.selectedTags = self.state
        tagsView?.tags = tags
    }
    
    func binding() {
        categoriesRelay
            .asDriver()
            .skip(1)
            .drive(with: self, onNext: { owner, tags in
                owner.updateTags(tags)
            }).disposed(by: bag)
        
        selectedTags
            .asDriver()
            .drive(with: self, onNext: { owner, tags in
//                guard let tags = tags else { return }
//                debugPrint("seletedTags: \(tags)")
//                userDefault.set(tags, forKey: String(owner.typeInfo.id))
//                debugPrint("set UserDefulats: \(String(describing: userDefault.object(forKey: String(owner.typeInfo.id))))")
//                owner.headerDelegate?.sendCategoryWithType(self, tags: owner.selectedTags.value, typeInfo: self.typeInfo)
            }).disposed(by: bag)
    }
    
    func configure(info: ClosetTypeInfo?, categories: [MCategoryInfo]?, state: [Int]?) {
        guard let typeInfo = info else { return }
        self.typeInfo = typeInfo
        sectionTitleLabel.text = "#\(typeInfo.name)"
        
        debugPrint("state: \(state)")
        if let state = state {
            self.state = state
        } else {
            self.state = []
        }
        
        debugPrint("HeaderView self State: \(self.state)")
        debugPrint("HeaderView configure State: \(state)")
        guard let categories = categories else { return }
        categoriesRelay.accept(categories.map { $0 })
        
    }
}

extension CategoryHeaderView: ItemTagsViewDelegate {
    func  selectItemTags(view: CategoryTagsView, categoryInfo: MCategoryInfo) {
        let id = categoryInfo.id
        
        // 태그뷰 모으기
        var tags = selectedTags.value
        // 중복제거
        if !tags.contains(id) {
            tags.append(id)
        } else {
            tags = tags.filter { $0 != id }
        }
        selectedTags.accept(tags)
        debugPrint("태그 모으기 : \(tags)")
        debugPrint("태그 모으기 : \(self.selectedTags.value)")
        userDefault.set(tags, forKey: String(typeInfo.id))
        debugPrint("set UserDefulats: \(String(describing: userDefault.object(forKey: String(self.typeInfo.id))))")
        self.headerDelegate?.sendCategoryWithType(self, tags: self.selectedTags.value, typeInfo: self.typeInfo)
        
    }
}
