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
        $0.register(withType: StyleCell.self)
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.registerHeader(withType: CategoryHeaderView.self)
    }
    lazy var dataSource = self.setInnerCollectionViewDataSource()
    
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
            .bind(to: innerCollectionView.rx.items(dataSource: setInnerCollectionViewDataSource()))
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
    
//    private func handlePrefetching(for indexPaths: [IndexPath]) {
//        let indexPathsToPrefetch = indexPaths.filter { indexPath in
//            switch self.dataSource.sectionModels[indexPath.section] {
//            case .styles: true
//            default: false
//            }
//        }
//        
//        guard !indexPathsToPrefetch.isEmpty else { return }
//        
//        for indexPath in indexPathsToPrefetch {
//            let sectionIndex = self.dataSource.sectionModels[indexPath.section]
//            switch sectionIndex {
//            case .styles(let header, let items):
//                debugPrint("innserScroll : \(indexPath)")
//            default: break
//            }
//        }
//    }
//    
}

// MARK: - 탭 이벤트 처리
extension InnerCollectionViewCell: TagsViewTouchDelegate {
    public func itemTagView(_ itemTagView: UIView, didSelectItemAt index: Int) {
        // TypeTag 탭했을 때 이벤트
        /*
            1. TypeTag 탭
            2. innerCollectionViewCell 의 어떤 섹션인지 전달
            3. setContentOffset 으로 이동
                -> 여기서 inner에서 처리할 지 parent 에서 처리할 지 알아야함.
         */
        
        
    }
    
    public func itemTagView(_ itemTagView: UIView, didDeSelectItemAt index: Int) {
        // TypeTag 탭했을 때 이벤트
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
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("indexPath : \(indexPath.section)")
        debugPrint("indexPath : \(indexPath.item)")
        var closetInfo: NewClosetInfo?

        let selectedItem = bindSectionsRelay.value[indexPath.section].items[indexPath.item]
        switch selectedItem {
        case .styles(let selectedInfo):
            debugPrint("selectedInfo : \(selectedInfo)")
            debugPrint("selectedInfo : \(closetInfo)")
            closetInfo = selectedInfo
        default: break
        }
        if closetInfo != nil {
            delegate?.innerCollectionViewCellDidTap(closetInfo)
        }
        
    }
 
    func setInnerCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> {
        RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .styles(let styleInfo):
                return collectionView.dequeueCell(withType: StyleCell.self, for: indexPath).then {
                    $0.configure(info: styleInfo)
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
    
    func styleSectionLayout() -> NSCollectionLayoutSection {
        
        // Size Property
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(210)
        )
        
        // Item
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth + 16),
            heightDimension: .absolute(432)
        )
        
        // Group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        group.interItemSpacing = .flexible(12)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(122)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
//        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 5)
        
        return section
    }
    
    // MARK: - 이중 스크롤 방지
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.innerCollectionViewDidScroll(innerCollectionView, contentOffset: scrollView.contentOffset)
    }

}
