//
//  HorizonCollectionViewCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/18/24.
//

import UIKit
import PinLayout
import RxDataSources
import RxCocoa
import RxSwift

final public class HorizonCollectionViewCell: UICollectionViewCell {
    
    private var bag = DisposeBag()
    private var bindClosets = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    
    // MARK: - UI Property
    // 헤더뷰
    var typeInfo = ClosetTypeInfo.init(id: 0, name: "")
    private var sectionTitleLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "#Type1")
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
    public var selectedTags = BehaviorRelay<[Int]>(value: [])
    // 콜렉션뷰
    private lazy var collectionView =  UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()).then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: StyleCell.self)
    }
    lazy var dataSource = self.horizonCollectionViewDataSource()
    
    
    
    
    // MARK: - Method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        binding()
        snapKitLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(sectionTitleLabel, itemTagHeaderWrapper, collectionView)
        
        tagsView = CategoryTagsView()
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(itemTagHeaderWrapper.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(430)
            
        }
        
    }
    
    private func binding() {
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        bindClosets
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
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
    
    private func updateTags(_ tags: [MCategoryInfo]) {
        tagsView?.tags = tags
    }
    
    
    func configureCollectionView(_ closets: [NewClosetInfo]?) {
        guard let closets = closets else { return }
        let models: [StyleTabItem] = closets.map { StyleTabItem.cloets($0) }
        bindClosets.accept([StyleTabSectionModel.closets(item: models)])
    }
    
    func configureTagsView(info: ClosetTypeInfo?, categories: [MCategoryInfo]?) {
        print("Header view Configure")
        guard let typeInfo = info else { return }
        self.typeInfo = typeInfo
        sectionTitleLabel.text = "#\(typeInfo.name)"
        
        guard let categories = categories else { return }
        categoriesRelay.accept(categories.map { $0 })
    }
    
}

extension HorizonCollectionViewCell: ItemTagViewDelegate {
    func selectItemTags(with tags: [Int]) {
        debugPrint("in HorizonCell : \(tags)")
    }
}
extension HorizonCollectionViewCell: UICollectionViewDelegate {
    
    func horizonCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> {
        RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> (configureCell:  { [ weak self] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .cloets(let styleInfo):
                return collectionView.dequeueCell(withType: StyleCell.self, for: indexPath).then {
                    $0.configure(info: styleInfo)
                }
            default:
                return UICollectionViewCell()
            }
        })
    }

    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.bindClosets.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
            
            let section = self.bindClosets.value[sectionIndex]
            var layoutSection: NSCollectionLayoutSection?
            switch section {
            case .closets:
                layoutSection = self.closetsSectionLayout()
            default:
                layoutSection =  .init(group: .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))))
            }
            return layoutSection
        }
    
        return layout
    }
    
    func closetsSectionLayout() -> NSCollectionLayoutSection {
        
        // Size Property
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(209)
        )
        
        // Item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth + 16),
            heightDimension: .absolute(430)
        )
        
        // Group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(12)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
}


