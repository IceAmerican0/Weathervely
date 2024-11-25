//
//  ClosetDetailViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/5/24.
//

import DesignSystem
import UIUtil
import UIKit
import FlexLayout
import RxSwift
import RxDataSources

public protocol ClosetDetailViewDelegate {
    func detailTapped(closetID: Int, tempID: Int)
}

public final class ClosetDetailViewController: RxBaseViewController<ClosetDetailViewModel> {
    private let shimmerView = DetailShimmerView()
    
    private let contentView = UIView()
    
    let navigationBar = CSNavigationView(
        .both(UIImage.leftArrow_black, UIImage.home_top)
    ).then {
        $0.setTitle(DiffTempHeaderComment.detailTitle.rawValue)
        $0.addBorder(.bottom, 1, .gray30)
    }
    
    lazy var parentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: MainDetailCell.self)
        $0.register(withType: WithItemCell.self)
        $0.register(withType: DiffTempCell.self)
        $0.registerHeader(withType: DiffTempDecoHeader.self)
        $0.registerHeader(withType: TitleLabelReusableHeader.self)
        //        $0.prefetchDataSource = self
    }
    lazy var dataSource = self.setParentCollectionView()
    
    var delegate: ClosetDetailViewDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }
    
    public override func layout() {
        super.layout()
        container.flex.define {
            $0.addItem(navigationBar)
            $0.addItem(shimmerView).grow(1)
            $0.addItem(contentView).grow(1).define {
                $0.addItem(parentCollectionView).grow(1)
            }.display(.none)
        }
    }
    
    public override func viewBinding() {
        super.viewBinding()
        parentCollectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        parentCollectionView.rx.prefetchItems
            .subscribe(with: self, onNext: { owner, indexPaths  in
                owner.handlePrefetching(for: indexPaths)
                
            }).disposed(by: bag)
        
        navigationBar.leftButtonDidTapRelay
            .drive(with: self) { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }
            .disposed(by: bag)
        
        navigationBar.rightButtonDidTapRelay
            .drive(with: self) { owner, _ in
                owner.viewModel.navigationPoptoRootRelay.accept(Void())
            }.disposed(by: bag)
    }
    
    public override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.detailViewSections
            .bind(to: parentCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.shimmerStatus
            .observe(on: MainScheduler.instance)
            .take(1)
            .subscribe(with: self) { owner, _ in
                owner.shimmerView.removeFromSuperview()
                owner.contentView.flex.display(.flex)
                owner.container.flex.layout()
            }.disposed(by: bag)
    }
    
    private func handlePrefetching(for indexPaths: [IndexPath]) {
        let indexPathsToPrefetch = indexPaths.filter { indexPath in
            switch self.dataSource.sectionModels[indexPath.section] {
            case .warmFirst, .warmSecond, .coolFirst, .coolSecond:
                return true
            default:
                return false
            }
        }
        
        guard !indexPathsToPrefetch.isEmpty else { return }
        
        
        for indexPath in indexPathsToPrefetch {
            let sectionModel = self.dataSource.sectionModels[indexPath.section]
            switch sectionModel {
                /*
                 [2, 17]
                 [2, 18]
                 [2, 19]
                 [2, 15]
                 [2, 15]
                 이런식으로 나온다.
                 20까지는 안나오고 prefetch할 item의 indexPath가 나온다
                 -> 60개 들어왔다고하면
                 -> 53,54,55...58,59 이렇게 들어온다.
                 -> 20으로 나눈 나머지가 18, 19 일때 prefetch
                 
                 ** 추가로 왼쪽 스크롤시에 prefetch 방지하기 위해서 currentPage 저장 필ㅇ
                 */
                
            case .warmFirst:
                var currentPage = viewModel.WFCurrentPage
                let maxPage = viewModel.WFMaxPage
                
                if (indexPath.item / 20) + 1 >= currentPage && currentPage < maxPage {
                    if  indexPath.item % 20 == 17 {
                        currentPage += 1
                        viewModel.WFCurrentPage = currentPage
                        prefetchData(section: sectionModel, page: currentPage)
                    }
                    
                }
                
            case .warmSecond:
                var currentPage = viewModel.WSCurrentPage
                let maxPage = viewModel.WSMaxPage
                if (indexPath.item / 20) + 1 >= currentPage && currentPage < maxPage {
                    if  indexPath.item % 20 == 17 {
                        currentPage += 1
                        viewModel.WSCurrentPage = currentPage
                        prefetchData(section: sectionModel, page: currentPage)
                    }
                    
                }
                
            case .coolFirst:
                var currentPage = viewModel.CFCurrentPage
                let maxPage = viewModel.CFMaxPage
                if (indexPath.item / 20) + 1 >= currentPage && currentPage < maxPage {
                    if  indexPath.item % 20 == 17 {
                        currentPage += 1
                        viewModel.CFCurrentPage = currentPage
                        prefetchData(section: sectionModel, page: currentPage)
                    }
                    
                }
                
            case .coolSecond:
                var currentPage = viewModel.CSCurrentPage
                let maxPage = viewModel.CSMaxPage
                if (indexPath.item / 20) + 1 >= currentPage && currentPage < maxPage {
                    if  indexPath.item % 20 == 17 {
                        currentPage += 1
                        viewModel.CSCurrentPage = currentPage
                        prefetchData(section: sectionModel, page: currentPage)
                    }
                    
                }
            default:
                
                break
            }
        }
    }
    
    
    func prefetchData(section: DetailViewSectionModel, page: Int) {
        switch section {
        case .warmFirst:
            viewModel.warmRowPrefetch(page, rowId: 1)
        case .warmSecond:
            viewModel.warmRowPrefetch(page, rowId: 2)
        case .coolFirst:
            viewModel.coolRowPrefetch(page, rowId: 1)
        case .coolSecond:
            viewModel.coolRowPrefetch(page, rowId: 2)
        default: break
        }
    }
}

extension ClosetDetailViewController: UICollectionViewDelegate {
    
    func setParentCollectionView() -> RxCollectionViewSectionedAnimatedDataSource<DetailViewSectionModel> {
        return RxCollectionViewSectionedAnimatedDataSource<DetailViewSectionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .fade),
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                guard let self else { return UICollectionViewCell() }
                switch item {
                case .mainDetail(let selectedInfo):
                    return collectionView.dequeueCell(withType: MainDetailCell.self, for: indexPath).then {
                        $0.configure(info: selectedInfo)
                    }
                case .withItem(let withItemInfo):
                    return collectionView.dequeueCell(withType: WithItemCell.self, for: indexPath).then {
                        $0.configure(info: withItemInfo)
                        $0.itemTap
                            .drive(with: self) { owner, _ in
                                owner.viewModel.toMall(url: withItemInfo.shopUrl ?? "")
                            }.disposed(by: $0.bag)
                    }
                case .firstRow(let rowInfo):
                    debuggerPrint("first: \(rowInfo.identity)")
                    return collectionView.dequeueCell(withType: DiffTempCell.self, for: indexPath).then {
                        $0.configure(info: rowInfo)
                        $0.itemTap
                            .drive(with: self) { owner, _ in
                                owner.delegate?.detailTapped(closetID: rowInfo.closetId, tempID: rowInfo.temperature.tempId)
//                                owner.viewModel.toDetailView(closetId: rowInfo.closetId, tempId: rowInfo.temperature.tempId)
                            }.disposed(by: $0.bag)
                    }
                case .secondRow(let rowInfo):
                    debuggerPrint("second: \(rowInfo.identity)")
                    return collectionView.dequeueCell(withType: DiffTempCell.self, for: indexPath).then {
                        $0.configure(info: rowInfo)
                        $0.itemTap
                            .drive(with: self) { owner, _ in
                                owner.delegate?.detailTapped(closetID: rowInfo.closetId, tempID: rowInfo.temperature.tempId)
//                                owner.viewModel.toDetailView(closetId: rowInfo.closetId, tempId: rowInfo.temperature.tempId)
                            }.disposed(by: $0.bag)
                    }
                }
            }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
                guard self != nil else { return UICollectionReusableView() }
                
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    switch dataSource[indexPath.section] {
                    case .mainDetail: 
                        return UICollectionReusableView()
                    case .withItem:
                        return collectionView.dequeueReusableHeaderView(
                            withType: TitleLabelReusableHeader.self,
                            for: indexPath
                        ).then {
                            $0.configure(text: DiffTempHeaderComment.withItemTitle.rawValue)
                        }
                    case .warmFirst:
                        return collectionView.dequeueReusableHeaderView(
                            withType: DiffTempDecoHeader.self,
                            for: indexPath
                        ).then {
                            $0.configure(
                                title: DiffTempHeaderComment.coolDiffTitle.rawValue,
                                description: DiffTempHeaderComment.coolDiffDescription.rawValue
                            )
                        }
                    case .warmSecond:
                        return collectionView.dequeueReusableHeaderView(
                            withType: TitleLabelReusableHeader.self,
                            for: indexPath
                        ).then {
                            $0.configure(text: DiffTempHeaderComment.secondCoolTitle.rawValue)
                        }
                    case .coolFirst:
                        return collectionView.dequeueReusableHeaderView(
                            withType: DiffTempDecoHeader.self,
                            for: indexPath
                        ).then {
                            $0.configure(
                                title: DiffTempHeaderComment.warmDiffTitle.rawValue,
                                description: DiffTempHeaderComment.warmDiffDescription.rawValue
                            )
                        }
                    case .coolSecond:
                        return collectionView.dequeueReusableHeaderView(
                            withType: TitleLabelReusableHeader.self,
                            for: indexPath
                        ).then {
                            $0.configure(text: DiffTempHeaderComment.secondWarmTitle.rawValue)
                        }
                    }
                default:
                    fatalError("Cannot Generate SupplementaryView")
                }
                return UICollectionReusableView()
            })
    }
    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.viewModel.detailViewSections.value.count else {
                debuggerPrint("Section index \(sectionIndex) out of range.")
                return nil
            }
            
            let section = self.viewModel.detailViewSections.value[sectionIndex]
            var layoutSection: NSCollectionLayoutSection?
            switch section {
            case .mainDetail:
                layoutSection = self.mainDetailLayout()
            case .withItem:
                layoutSection = self.withItemLayout()
            case .warmFirst(let item):
                let decoItem = NSCollectionLayoutDecorationItem.background(elementKind: CoolDecorationView.identifier)
                layoutSection = self.firstRowLayout(decoItem, item.count)
            case .coolFirst(let item):
                let decoItem = NSCollectionLayoutDecorationItem.background(elementKind: WarmDecorationView.identifier)
                layoutSection = self.firstRowLayout(decoItem, item.count)
            case .warmSecond(let item), .coolSecond(let item):
                layoutSection = self.secondRowLayout(item.count)
            }
            return layoutSection
        }
        layout.register(WarmDecorationView.self, forDecorationViewOfKind: WarmDecorationView.identifier)
        layout.register(CoolDecorationView.self, forDecorationViewOfKind: CoolDecorationView.identifier)
        
        return layout
    }
    
    // MARK: - MainDetailSection Layout
    func mainDetailLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(636.5)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
        return section
    }
    
    // MARK: - withItemScction Layout
    func withItemLayout() -> NSCollectionLayoutSection { // 180 + 12 + 19 + 4 + 17 = 231 + (4 + 17) / 29.5 + (4 + 17)
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let groupWidth = itemWidth * 3 + 32
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(233)
            //            heightDimension: .absolute(254) // FIXME: - 카테고리 영역 높이 = 21
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        /// Group = 한 화면에 들어가는 item을 묶은 단위
        /// https://ios-development.tistory.com/945
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(263)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(23)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12 , leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // MARK: - DiffTempSection Layout
    func firstRowLayout(_ decoItem: NSCollectionLayoutDecorationItem,_ itemCount: Int) -> NSCollectionLayoutSection {
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let groupWidth = itemWidth * 3 + 32
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        if itemCount != 0 {
            // Header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.decorationItems = [decoItem]
            section.boundarySupplementaryItems = [sectionHeader]
        }
        section.contentInsets = NSDirectionalEdgeInsets(top: 19.5, leading: 20, bottom: 20, trailing: 20)
        return section
    }
    
    func secondRowLayout(_ itemCount: Int) -> NSCollectionLayoutSection {
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let groupWidth = itemWidth * 3 + 32
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(groupWidth),
            heightDimension: .absolute(180)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        if itemCount != 0 {
            
            // Header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(23)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
            section.boundarySupplementaryItems = [sectionHeader]
        }
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 50, trailing: 20)
        return section
    }
    
}

