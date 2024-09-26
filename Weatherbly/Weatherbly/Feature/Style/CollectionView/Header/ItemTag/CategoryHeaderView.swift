//
//  CategoryHeaderView.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/5/24.
//
import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift
import Then

protocol CategoryHeaderViewDelegate: AnyObject {
    func sendCategoryWithType(tags: [Int], typeInfo: ClosetTypeInfo)
}

final class CategoryHeaderView : UICollectionReusableView {
    
    private var bag = DisposeBag()
    
    public weak var headerDelegate: CategoryHeaderViewDelegate?
    
    public var typeInfo = ClosetTypeInfo.init(id: 0, name: "")
    
    var state: [Int] = []
    
    private let container = UIView()
    
    private var sectionTitleLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "#Type1")
    
    private var categoriesRelay = BehaviorRelay<[StyleMediumCategoryInfo]>(value: [
        StyleMediumCategoryInfo(id: 28, name: "니트/스웨터"),
        StyleMediumCategoryInfo(id: 31, name: "긴소매 티셔츠"),
        StyleMediumCategoryInfo(id: 32, name: "셔츠/블라우스"),
        StyleMediumCategoryInfo(id: 33, name: "피케/카라티셔츠"),
        StyleMediumCategoryInfo(id: 34, name: "반소매 티셔츠"),
        StyleMediumCategoryInfo(id: 35, name: "민소매 티셔츠"),
        StyleMediumCategoryInfo(id: 37, name: "기타 상의")
    ])
    
    public lazy var tagsView = CategoryTagsView().then {
        $0.backgroundColor = .white
        $0.tagsViewDelegate = self
    }
    
    // selectedTags 상태를 관리
    public var selectedTags = BehaviorRelay<[Int]>(value: [])
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sectionTitleLabel.text = ""
        selectedTags = BehaviorRelay<[Int]>(value: [])
        tagsView.bag = DisposeBag()
        tagsView.tags = []  // 태그 뷰 초기화
        tagsView.scrollView.setContentOffset(.zero, animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }
    
    private func setLayout() {
        container.pin.all()
        container.flex.layout()
    }
    
    func layout() {
        flex.addItem(container).define {
            $0.addItem(sectionTitleLabel).marginLeft(20).marginTop(16)
            $0.addItem(tagsView).width(Constants.screenWidth).marginTop(17).height(66)
        }
    }
    
    func binding() {
        categoriesRelay
            .asDriver()
            .skip(1)
            .drive(with: self, onNext: { owner, tags in
                owner.tagsView.configure(tags: tags, selectedTags: owner.state)
            }).disposed(by: bag)
        
        selectedTags
            .asDriver()
            .filter { $0.count > 0 }
            .drive(with: self, onNext: { owner, tags in
                owner.tagsView.configure(selectedTags: tags)
            }).disposed(by: bag)
    }
    
    func configure(info: ClosetTypeInfo?, categories: [StyleMediumCategoryInfo]?, state: [Int]?) {
        guard let typeInfo = info else { return }
        self.typeInfo = typeInfo
        sectionTitleLabel.text = "#\(typeInfo.name)"
        
        if let state {
            self.state = state
        } else {
            self.state = []
        }
        
        guard let categories else { return }
        categoriesRelay.accept(categories.map { $0 })
        
    }
}

extension CategoryHeaderView: ItemTagsViewDelegate {
    func selectItemTags(categoryInfo: StyleMediumCategoryInfo) {
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
        userDefault.set(tags, forKey: String(typeInfo.id))
        self.headerDelegate?.sendCategoryWithType(tags: self.selectedTags.value, typeInfo: self.typeInfo)
        
    }
}
