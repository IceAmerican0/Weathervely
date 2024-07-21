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
    
    // MARK: - 전역변수 & delegate
    private var bag = DisposeBag()
    weak var delegate: StyleTabClosetTouchDelegate?
    private var cellViewModel = InnerCellViewModel()
    // MARK: - UI Property
//    private var bindSectionsRelay = BehaviorRelay<[StyleTabSectionModel]>(value: [])
    private lazy var innerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setInnerLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.register(withType: StyleCell.self)
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.registerReusableView(withType: CategoryHeaderView.self, kind: .sectionHeader)
    }
    lazy var dataSource = self.setInnerCollectionViewDataSource()
    var selectedTags: [Int] = []
    
    // MARK: - lifeCycle
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
    
    
    // MARK: - Layout
    private func layout() {
        contentView.pin.all()
        contentView.addSubview(innerCollectionView)
        innerCollectionView.pin.all()
    }
    
    // MARK: - Binding
    func binding() {
        
        innerCollectionView.rx
            .setDelegate(self)
            .disposed(by: bag)

        cellViewModel.bindSectionsRelay
            .bind(to: innerCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        innerCollectionView.rx.prefetchItems
            .asDriver()
            .drive(with: self) { owner, indexPaths in
//                owner.handlePrefetching(for: indexPaths)
            }.disposed(by: bag)
        
        NotificationCenter.default.rx.notification(.styleTagTap)
            .compactMap { $0.userInfo }
            .compactMap { $0["typeTagInfo"] as? ClosetTypeInfo }
            .bind(with: self) { owner, tagInfo in
                
                if var offset = owner.offsetYForSection(with: tagInfo) {
                    let curOffsetY = owner.innerCollectionView.contentOffset.y
                    /// 현재 innerCV의 위치가 배너+VC타이틀+섹션인셋 높이(157 +-1) 보다 작으면 차이만큼 더 스크롤 해야한다.
                    debugPrint("curOfssetY No 1: \(curOffsetY)")
                    if 0...132 ~= curOffsetY {
                        offset.y += (148 - curOffsetY)
                    }
                    owner.innerCollectionView.setContentOffset(offset, animated: true)
                    debugPrint("curOfssetY No 2: \(curOffsetY)")
                }
               
            }
            .disposed(by: bag)
    }
    
    // MARK: - Method
    private func offsetYForSection(with tagInfo: ClosetTypeInfo) -> CGPoint? {
        if let sectionIndex = self.cellViewModel.bindSectionsRelay.value.firstIndex(where: { section  in
            if case .styles(let header, _) = section,
            header.typeInfo.id == tagInfo.id {
                return true
            }
            return false
        }) {
            let scrollView = self.innerCollectionView
            guard let layoutAttributes = scrollView.layoutAttributesForItem(at: IndexPath(item: 0, section: sectionIndex)) else { return nil }
            if sectionIndex == 0 {
                scrollView.contentOffset.y = 0
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: true)
            }
            layoutAttributes.frame.origin.y -= 56 // ection의 titleLabel 높이
            layoutAttributes.frame.origin.x -= 16 // section ContentInset
            return layoutAttributes.frame.origin
        }
        return .zero
    }

    // MARK: - Configure
    func configure(_ sectionsInfo: [StyleTabSectionModel]?) {
        guard let sectionsInfo = sectionsInfo else { return }
        cellViewModel.bindSectionsRelay.accept(sectionsInfo)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        
//        cellViewModel.bindSectionsRelay.accept([])
    }
}

// MARK: - 테그 탭 이벤트 처리
extension InnerCollectionViewCell: CategoryHeaderViewDelegate {

    func sendCategoryWithType(_ view: CategoryHeaderView, tags: [Int], typeInfo: ClosetTypeInfo) {
        
        self.selectedTags = tags
        let updatedSections = self.cellViewModel.bindSectionsRelay.value
        if let sectionIndex = updatedSections.firstIndex(where: { section in
            if case .styles(let header, _) = section, header.typeInfo.id == typeInfo.id {
                
                return true
            }
            return false
        }) {
            cellViewModel.getFilteredByCategories(with: tags, in: sectionIndex, typeInfo : typeInfo)
        }
    }
}

extension InnerCollectionViewCell: UICollectionViewDelegate {
    
    // MARK: - 탭처리
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("indexPath : \(indexPath.section)")
        debugPrint("indexPath : \(indexPath.item)")
        if let cell = collectionView.cellForItem(at: indexPath) as? StyleCell {
            let selectedInfo = cell.closetInfo
            NotificationCenter.default.post(name: .styleClosetTap, object: nil, userInfo: ["selectedCloset" : selectedInfo])
        }
        
    }
 
    func setInnerCollectionViewDataSource() -> RxCollectionViewSectionedAnimatedDataSource<StyleTabSectionModel> {
        RxCollectionViewSectionedAnimatedDataSource<StyleTabSectionModel> (animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .automatic),configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
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
                        userDefault.synchronize()
                        $0.headerDelegate = self
                        let state: [Int] = (userDefault.object(forKey: String(headerInfo.typeInfo.id)) ?? []) as! [Int]
                        debugPrint("📌📌 \(headerInfo.typeInfo.name): \(headerInfo.typeInfo.id)   \(state)")
                        $0.configure(info: headerInfo.typeInfo, categories: headerInfo.categories, state: state)
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
            guard sectionIndex < self.cellViewModel.bindSectionsRelay.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
    
            let section = self.cellViewModel.bindSectionsRelay.value[sectionIndex]
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
    
    // TODO: - // Item 레이아웃 사이즈 변경
    func styleSectionLayout() -> NSCollectionLayoutSection {
         // header + item => 572
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
        group.interItemSpacing = .fixed(12)
        
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 5)
        
        return section
    }
    
    // MARK: - 이중 스크롤 방지
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.innerCollectionViewDidScroll(innerCollectionView, contentOffset: scrollView.contentOffset)
    }

}

