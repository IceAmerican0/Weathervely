//
//  NewStyleVC.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/11/24.
//

import UIKit
import FlexLayout
import RxSwift
import RxDataSources
import RxGesture

final class StyleViewController: RxBaseViewController<StyleViewModel> {
    
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "스타일").then {
        $0.sizeToFit()
    }
    lazy private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.registerHeader(withType: CategoryHeaderView.self)
        $0.register(withType: BannerCell.self)
        $0.register(withType: StyleCell.self)
        $0.register(withType: InnerCollectionViewCell.self)
    }
    
    private lazy var rxDataSources = setRxDataSources()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        container.flex.layout()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define { container in
            container.addItem(titleLabel).marginHorizontal(20).marginTop(11.5).marginBottom(17.5).height(23)
            container.addItem(collectionView).grow(1)
        }
        
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushDetailView(_:)), name: .styleClosetTap, object: nil)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.bindSectionsRelay
            .bind(to: collectionView.rx.items(dataSource: setRxDataSources()))
            .disposed(by: bag)
    }
}

extension StyleViewController: StyleTabClosetTouchDelegate {
    
    // MARK: - InnerCV Cell Tap Event
    @objc func pushDetailView(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any],
            let selectedCloset = data["selectedCloset"] as? NewClosetInfo {
            let detailVM = ClosetDetailViewModel(closetId: selectedCloset.closetId, tempId: selectedCloset.temperature.tempId)
            let detailVC = ClosetDetailViewController(detailVM)
            self.viewModel.navigationPushViewControllerRelay.accept(detailVC)
            }
        }
//    func innerCollectionViewCellDidTap(_ selectedInfo: NewClosetInfo?) {
//        guard let info = selectedInfo else { return }
//        let detailVM = ClosetDetailViewModel(closetId: info.closetId, tempId: info.temperature.tempId)
//        let detailVC = ClosetDetailViewController(detailVM)
//        self.viewModel.navigationPushViewControllerRelay.accept(detailVC)
//    }

    // MARK: - 이중 스크롤 방지
    func innerCollectionViewDidScroll(_ innerCollectionView: UICollectionView, contentOffset: CGPoint) {
        var offsetY = contentOffset.y
        let titleLabelAreaHeight = titleLabel.lineHeight + 28.5
        let bannerSectionHeight = CGFloat(80)
        let parentScrollOffsetY = titleLabelAreaHeight + bannerSectionHeight
        
        if offsetY <= 0 { // innerCV 최상단
            collectionView.becomeFirstResponder()
            
            /// collectionView의 스크롤 높이가 가장 최상단일때
            if collectionView.contentOffset.y <= 0 {
                collectionView.contentOffset.y = 0
                innerCollectionView.contentOffset.y = 0
                innerCollectionView.setContentOffset(CGPoint(x: innerCollectionView.contentOffset.x, y: 0), animated: true)
            } else {
                /// collectionVie의 스크롤의 높이가 0보다 크면서 parentScrollOffsetY 보다 작을 때
                /// 즉, 배너섹션의 끝 영역까지
                collectionView.contentOffset.y += offsetY
                innerCollectionView.contentOffset.y = 0
            }
        } else {
        
            if collectionView.contentOffset.y <= parentScrollOffsetY {
                collectionView.becomeFirstResponder()
                collectionView.contentOffset.y += offsetY
                
                if collectionView.contentOffset.y > parentScrollOffsetY {
                    collectionView.contentOffset.y = parentScrollOffsetY
                }
                innerCollectionView.contentOffset.y = 0
            } else { // 부모CV가 무시 기준을 도달했을 때 이후 // 근데 innserCV 스크롤하는 시점
                
                if collectionView.contentOffset.y > parentScrollOffsetY {
                    collectionView.contentOffset.y = parentScrollOffsetY
                }
                
                innerCollectionView.becomeFirstResponder()
                
                // innerCV가 끝에 도달했을 때
                let innerCVContentHeight = innerCollectionView.contentSize.height
                let innerCVFrameHeight = innerCollectionView.frame.height
                if offsetY >= innerCVContentHeight - innerCVFrameHeight {
                    offsetY = innerCVContentHeight - innerCVFrameHeight
                }
            }
        }
    }
    
}
extension StyleViewController: UICollectionViewDelegate {

    // MARK: - 이중 스크롤 방지
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let titleLabelAreaHeight = titleLabel.lineHeight + 28.5
        let bannerSectionHeight = CGFloat(80)
        //
        let shouldFixedY = titleLabelAreaHeight + bannerSectionHeight
        
        let parentCV = self.collectionView
        var parentOffsetY = parentCV.contentOffset.y
        
        //
        if parentOffsetY < shouldFixedY { // 기준선 도달 전
            parentOffsetY = 0
            parentCV.isScrollEnabled = true
        } else { // 기준선 도달 이후
            parentOffsetY = shouldFixedY
            parentCV.isScrollEnabled = false
            
        }
//        debugPrint("parentOffsetY : \(parentOffsetY)")
//        debugPrint("scrollY : \(scrollView.contentOffset.y )")
        
    }
    
    // MARK: - DataSource
    func setRxDataSources() ->  RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> {
        RxCollectionViewSectionedReloadDataSource<StyleTabSectionModel> (configureCell: { [ weak self ] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .banner(let banner):
                return collectionView.dequeueCell(withType: BannerCell.self, for: indexPath).then {
                    $0.bannerImageView.image = banner.styleBanner
                }
                
            case .type(let innerSectionsArr):
                return collectionView.dequeueCell(withType: InnerCollectionViewCell.self, for: indexPath).then {
                    $0.delegate = self // 스크롤 중첩이슈 해결을 위한 delegate
                    $0.configure(innerSectionsArr)
                }
                
            default: return UICollectionViewCell()
            }
            
        }, configureSupplementaryView: { [ weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            // TODO: - header styleTagHeaderView 넣기
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                switch dataSource[indexPath.section] {
                    
                case .types(let types, _):
                    return collectionView.dequeueReusableHeaderView(withType: StyleTagHeaderView.self, for: indexPath).then {
                        $0.configureTag(types)
                    }
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
    
    func setSectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            guard sectionIndex < self.viewModel.bindSectionsRelay.value.count else {
                print("Section index \(sectionIndex) out of range.")
                return nil
            }
            
            let section = self.viewModel.bindSectionsRelay.value[sectionIndex]
            var layoutSection: NSCollectionLayoutSection?
            switch section {
            case .banner:
                layoutSection = self.bannerSectionLayout()
            case .types:
                layoutSection = self.typesSectionLayout()
                
            default:
                break
            }
            
            return layoutSection
        }
        
        return layout
    }
    
    func bannerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constants.screenWidth - 20),
            heightDimension: .absolute(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        return section
    }
    
    func typesSectionLayout() -> NSCollectionLayoutSection {
        
        // item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(56)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        // Section
        sectionHeader.pinToVisibleBounds = true
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
