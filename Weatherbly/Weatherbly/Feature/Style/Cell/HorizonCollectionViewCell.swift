////
////  HorizonCollectionViewCell.swift
////  Weatherbly
////
////  Created by 최수훈 on 7/18/24.
////
//
//import UIKit
//import RxCocoa
//import RxDataSources
//import RxSwift
//
//final public class HorizonCollectionViewCell: UICollectionViewCell {
//    
//    private var bag = DisposeBag()
//    private var cellViewModel = HorizonCellViewModel()
//    
//    // FIXME: - mock
//    var typeInfo = ClosetTypeInfo(id: 0, name: "")
//    // MARK: - Delegate
//    weak var itemTouchDelegate: StyleTabClosetTouchDelegate?
//    // MARK: - UI Property
//    // 헤더뷰
//    private var sectionTitleLabel = LabelMaker(
//        font: UIFont.title_3_B,
//        fontColor: UIColor.black,
//        alignment: .left
//    ).make(text: "#Type1")
//    
//    private var itemTagHeaderWrapper = UIStackView()
//    private var tagsView: CategoryTagsView? // 태그 뷰를 캐싱
//    
//    // 콜렉션뷰
//    private lazy var collectionView =  UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()).then {
//        $0.showsHorizontalScrollIndicator = false
//        $0.showsVerticalScrollIndicator = false
//        $0.register(withType: StyleCell.self)
//    }
//    lazy var dataSource = self.horizonCollectionViewDataSource()
//    
//    // MARK: - LifeCycle
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        binding()
//        snapKitLayout()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupView() {
//        self.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubviews(sectionTitleLabel, itemTagHeaderWrapper, collectionView)
//        
//        tagsView = CategoryTagsView(identifier: UUID().uuidString,typeInfo: typeInfo)
//        tagsView?.backgroundColor = .white
//        tagsView?.numRows = 2
//        tagsView?.tagsViewDelegate = self
//        if let tagsView = tagsView {
//            itemTagHeaderWrapper.addSubview(tagsView)
//        }
//    }
//    
//    
//    // MARK: - Layout
//    func snapKitLayout() {
//        sectionTitleLabel.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview().offset(20)
//            $0.trailing.equalToSuperview()
//            $0.height.equalTo(56)
//        }
//        
//        itemTagHeaderWrapper.snp.makeConstraints {
//            $0.top.equalTo(sectionTitleLabel.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(66)
//        }
//        tagsView?.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        collectionView.snp.makeConstraints {
//            $0.top.equalTo(itemTagHeaderWrapper.snp.bottom).offset(20)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(430)
//            
//        }
//        
//    }
//    
//    // MARK: - Binding
//    private func binding() {
//        viewModelBinding()
//        viewBinding()
//    }
//    private func viewBinding() {
//
//        collectionView.rx
//            .setDelegate(self)
//            .disposed(by: bag)
//
//        collectionView.rx.prefetchItems
//            .asDriver()
//            .drive(with: self) { owner, indexPaths in
//                owner.handlePrefetching(for: indexPaths)
//            }.disposed(by: bag)
//    }
//    private func viewModelBinding() {
//        
//        cellViewModel.bindClosets
//            .bind(to: collectionView.rx.items(dataSource: dataSource))
//            .disposed(by: bag)
//        
//        cellViewModel.categoriesRelay
//            .asDriver()
//            .drive(with: self, onNext: { owner, tags in
//                owner.updateTags(tags)
//            }).disposed(by: bag)
//    }
//    
//    // MARK: - Configure
//    private func updateTags(_ tags: [MCategoryInfo]) {
//        tagsView?.tags = tags
//    }
//    
//    func configureCollectionView(_ closets: [NewClosetInfo]?) {
//        guard let closets = closets else { return }
//        let closetInfoes: [StyleTabItem] = closets.map { StyleTabItem.closets($0) }
//        cellViewModel.sectionItems.accept(closetInfoes)
//        cellViewModel.getMaxPage()
//        cellViewModel.bindClosets.accept([StyleTabSectionModel.closets(item: closetInfoes)])
//    }
//    
//    func configureTagsView(info: ClosetTypeInfo?, categories: [MCategoryInfo]?) {
//        print("Header view Configure")
//        guard let typeInfo = info else { return }
//        cellViewModel.typeInfo = typeInfo
//        sectionTitleLabel.text = "#\(typeInfo.name)"
//        
//        guard let categories = categories else { return }
//        cellViewModel.categoriesRelay.accept(categories.map { $0 })
//    }
//    
//    // MARK: - Prefetch
//    private func handlePrefetching(for indexPaths: [IndexPath]) {
//        let indexPathsToPrefetch = indexPaths.filter { indexPath in
//            switch self.dataSource.sectionModels[indexPath.section] {
//            case .closets: true
//            default: false
//            }
//        }
//        guard !indexPathsToPrefetch.isEmpty else { return }
//        for indexPath in indexPathsToPrefetch {
//            let sectionModel = self.dataSource.sectionModels[indexPath.section]
//            switch sectionModel {
//            case .closets:
//                var currentPage = cellViewModel.currentPage
//                let maxPage = cellViewModel.maxPage
//                debugPrint("\n\ncurPage: \(currentPage)")
//                debugPrint("curIndex: \(indexPath.item)")
//                
//                if (indexPath.item / 20) + 1 >= currentPage && currentPage < maxPage {
//                    if  indexPath.item % 20 == 17 {
//                        currentPage += 1
//                        cellViewModel.currentPage = currentPage
//                        prefetchData(page: currentPage)
//                    }
//                    
//                }
//                break
//            default: break
//            }
//        }
//    }
//    
//    private func prefetchData(page: Int) {
//        cellViewModel.prefetchClosets(page)
//    }
//    
//    
//}
//
//// MARK: - 테그 탭 이벤트
//extension HorizonCollectionViewCell: ItemTagsViewDelegate {
//    func selectItemTags(view: CategoryTagsView, categoryInfo: MCategoryInfo) {
//        
//    }
//
//    
//    func getCategoryParam(with tags: [Int]) -> String {
//        var itemsString = ""
//        for item in tags {
//            if item == tags.last {
//                itemsString += String(item) + ","
//            } else {
//                itemsString += String(item)
//            }
//        }
//        return itemsString
//    }
//    
//    func selectItemTags(view: CategoryTagsView, with tags: [Int]) {
//        
//        cellViewModel.getFilteredByCategories(with: tags, { newClosets in
//            self.configureCollectionView(newClosets)
//        })
//    }
//}
//extension HorizonCollectionViewCell: UICollectionViewDelegate {
//    
//    // MARK: - detailView 띄우는 로직
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? StyleCell {
//            let selectedInfo = cell.closetInfo
//        }
//    }
//    // MARK: - DataSource
//    func horizonCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> {
//        RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> (configureCell:  { [ weak self] dataSource, collectionView, indexPath, item in
//            guard self != nil else { return UICollectionViewCell() }
//            
//            switch item {
//            case .closets(let styleInfo):
//                return collectionView.dequeueCell(withType: StyleCell.self, for: indexPath).then {
//                    $0.configure(info: styleInfo)
//                }
//            default:
//                return UICollectionViewCell()
//            }
//        })
//    }
//
//    
//    func setSectionLayout() -> UICollectionViewCompositionalLayout {
//        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
//            
//            guard let self = self else { return nil }
//            guard sectionIndex < cellViewModel.bindClosets.value.count else {
//                print("Section index \(sectionIndex) out of range.")
//                return nil
//            }
//            
//            let section = cellViewModel.bindClosets.value[sectionIndex]
//            var layoutSection: NSCollectionLayoutSection?
//            switch section {
//            case .closets:
//                layoutSection = self.closetsSectionLayout()
//            default:
//                layoutSection =  .init(group: .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))))
//            }
//            return layoutSection
//        }
//    
//        return layout
//    }
//    
//    // MARK: - collectionView Layout
//    func closetsSectionLayout() -> NSCollectionLayoutSection {
//        
//        // Size Property
//        let itemWidth = (Constants.screenWidth - 20 ) / 3
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(itemWidth),
//            heightDimension: .absolute(209)
//        )
//        
//        // Item
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(itemWidth + 16),
//            heightDimension: .absolute(430)
//        )
//        
//        // Group
//        let group = NSCollectionLayoutGroup.vertical(
//            layoutSize: groupSize,
//            subitems: [item, item]
//        )
//        group.interItemSpacing = .fixed(12)
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//        return section
//    }
//    
//}
//
//
