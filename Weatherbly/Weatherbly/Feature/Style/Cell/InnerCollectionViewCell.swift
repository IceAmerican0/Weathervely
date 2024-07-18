//
//  InnerCollectionViewCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import UIKit
import PinLayout
import RxDataSources
import RxSwift
import RxCocoa

final public class InnerCollectionViewCell: UICollectionViewCell {
    
    private var bag = DisposeBag()
    weak var delegate: InnerCollectionViewCellDelegate?

    private var bindSectionsRelay = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    private lazy var innerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setInnerLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: HorizonCollectionViewCell.self)
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.registerHeader(withType: CategoryHeaderView.self)
    }
    lazy var dataSource = self.setInnerCollectionViewDataSource()
    var selectedTags: [Int] = []
    public override init(frame: CGRect) {
        super.init(frame: frame)
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        contentView.pin.all()
        contentView.addSubview(innerCollectionView)
        innerCollectionView.pin.all()
    }
    
    func binding() {
        
        innerCollectionView.rx
            .setDelegate(self)
            .disposed(by: bag)

        bindSectionsRelay
            .take(2)
            .bind(to: innerCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        innerCollectionView.rx.prefetchItems
            .asDriver()
            .drive(with: self) { owner, indexPaths in
//                owner.handlePrefetching(for: indexPaths)
            }.disposed(by: bag)
    }
    
    func configure(_ sectionsInfo: [StyleTabSectionModel]?) {
        guard let sectionsInfo = sectionsInfo else { return }
        bindSectionsRelay.accept(sectionsInfo)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

// MARK: - 탭 이벤트 처리
extension InnerCollectionViewCell: CategoryHeaderViewDelegate {
    
    func getCategoryParam(with tags: [Int]) -> String {
        var itemsString = ""
        for item in tags {
            if item == tags.last {
                itemsString += String(item) + ","
            } else {
                itemsString += String(item)
            }
        }
        return itemsString
    }
    
    private func updateItemsForSection(sectionIndex: Int, newItems: [StyleTabItem]) {
        var updatedSections = bindSectionsRelay.value
            if sectionIndex < updatedSections.count {
                if case .styles(let header, _) = updatedSections[sectionIndex] {
                    updatedSections[sectionIndex] = .styles(header: header, items: newItems)
                    bindSectionsRelay.accept(updatedSections)

                    let indexPaths = (0..<newItems.count).map { IndexPath(item: $0, section: sectionIndex) }
                                    innerCollectionView.reloadItems(at: indexPaths)
                    
                }
            }
      }
    
    func sendCategoryWithType(_ view: CategoryHeaderView?, tags: [Int], typeInfo: ClosetTypeInfo) {
        
        self.selectedTags = tags
        // API 재호출
        let dataSource = NewClosetDataSource()
        switch tags.isEmpty {
        case true:
            dataSource.getClosetWithType(typeID: typeInfo.id, page: 1)
                .subscribe(with: self) { owner, response in
                    let newClosets = response.data.closets
                    let updatedSections = owner.bindSectionsRelay.value
                    if let sectionIndex = updatedSections.firstIndex(where: { section in
                        if case .styles(let header, _) = section, header.typeInfo.id == typeInfo.id {
                         
                            return true
                        }
                        return false
                    }) {
                        debugPrint("sectionIndex: \(sectionIndex)")
                        let cell = owner.innerCollectionView.cellForItem(at: IndexPath(item: 0, section: sectionIndex)) as? HorizonCollectionViewCell
                        cell?.configureCollectionView(newClosets)
                    }
                }
                .disposed(by: bag)
            
        case  false:
            let cgParam = getCategoryParam(with: tags)
            dataSource.closetWithCategory(typeID: typeInfo.id, page: 1, items: cgParam)
                .subscribe(with: self) { owner, response in
                    let newClosets = response.data.closets
                    let sections = owner.bindSectionsRelay.value
                    if let sectionIndex = sections.firstIndex(where: { section in
                        if case .styles(let header, _) = section, header.typeInfo.id == typeInfo.id {
                            
                            return true
                        }
                        return false
                    }) {
                        debugPrint("sectionIndex: \(sectionIndex)")
                        // 각 섹션의 item은 한개이므로 item의 index = 0
                        let cell = owner.innerCollectionView.cellForItem(at: IndexPath(item: 0, section: sectionIndex)) as? HorizonCollectionViewCell
                        cell?.configureCollectionView(newClosets)
                    }
                }
                .disposed(by: bag)
        }
        
       
            
    }
}

//extension InnerCollectionViewCell: UICollectionViewDataSourcePrefetching {
//    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            let model = bindSectionsRelay.value[indexPath.section]
//        }
//        let page: Int = 1
//        let typeId: Int
//        let mCategories: [Int]
//    }
//    
// 
//    
//}
extension InnerCollectionViewCell: UICollectionViewDelegate {
    
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        debugPrint("indexPath : \(indexPath.section)")
//        debugPrint("indexPath : \(indexPath.item)")
//        var closetInfo: NewClosetInfo?
//
//        let selectedItem = bindSectionsRelay.value[indexPath.section].items[indexPath.item]
//        switch selectedItem {
//        case .styles(let selectedInfo):
//            debugPrint("selectedInfo : \(selectedInfo)")
//            debugPrint("selectedInfo : \(closetInfo)")
//            closetInfo = selectedInfo
//        default: break
//        }
//        if closetInfo != nil {
//            delegate?.innerCollectionViewCellDidTap(closetInfo)
//        }
//        
//    }
 
    func setInnerCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> {
        RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .styles(let styleInfo):
                return collectionView.dequeueCell(withType: HorizonCollectionViewCell.self, for: indexPath).then {
                    $0.configureTagsView(info: styleInfo.typeInfo, categories: styleInfo.categories)
                    $0.configureCollectionView(styleInfo.closets)
                    
                }
            default:
                return UICollectionViewCell()
            }
            
        }, configureSupplementaryView: { [ weak self ] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                switch dataSource[indexPath.section] {
                case .styles(let headerInfo, _):
                    let header = collectionView.dequeueReusableHeaderView(withType: CategoryHeaderView.self, for: indexPath).then {
                        $0.headerDelegate = self
                        $0.selectedTags.accept(self!.selectedTags)
                        $0.configure(info: headerInfo.typeInfo, categories: headerInfo.categories)
                    }
                    return header
                    // TODO: - ItemTagHeaderView 이벤트 반드시 받아올 수 있어야 함.
                    
                default:
                    return UICollectionReusableView()
                }
            default:
                fatalError("Fail to Generate SupplementaryView")
            }
            return UICollectionReusableView()
        })
    }
    
    func setInnerLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.bindSectionsRelay.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
    
            let section = self.bindSectionsRelay.value[sectionIndex]
            var layoutSection: NSCollectionLayoutSection?
            switch section {
            case .styles:
                layoutSection = self.styleSectionLayout()
                
            default:
                layoutSection =  .init(group: .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(1))))
            }
            return layoutSection
        }
        return layout
    }
    
    // FIXME: - 아이템에 헤더까지 포함한 레이아웃
    func styleSectionLayout() -> NSCollectionLayoutSection {
         // header + item => 572
        // Size Property
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(572)
        )
        
        // Item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(572)
        )
        
        // Group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 36
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 5)
        
        return section
    }
    
    // TODO: - // Item 레이아웃 사이즈 변경
//    func styleSectionLayout() -> NSCollectionLayoutSection {
//         // header + item => 572
//        // Size Property
//        let itemWidth = (Constants.screenWidth - 20 ) / 3
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .absolute(432)
//        )
//        
//        // Item
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .absolute(432)
//        )
//        
//        // Group
//        let group = NSCollectionLayoutGroup.vertical(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//        
//        // Header
//        let headerSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .absolute(122)
//        )
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerSize,
//            elementKind: UICollectionView.elementKindSectionHeader,
//            alignment: .topLeading
//        )
//        
//        let section = NSCollectionLayoutSection(group: group)
////        section.orthogonalScrollingBehavior = .continuous
//        section.boundarySupplementaryItems = [sectionHeader]
//        section.interGroupSpacing = 36
//        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 5)
//        
//        return section
//    }
    
    // MARK: - 이중 스크롤 방지
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.innerCollectionViewDidScroll(innerCollectionView, contentOffset: scrollView.contentOffset)
    }

}

