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
import Then

public final class StyleViewController: RxBaseViewController<StyleViewModel> {
    private let shimmerView = StyleShimmerView()
    
    private let contentView = UIView()
    
    private var titleLabel = LabelMaker(font: UIFont.title_3_B).make(text: "스타일").then {
        $0.sizeToFit()
    }
    
    lazy private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.registerHeader(withType: StyleTagHeaderView.self)
        $0.register(withType: BannerCell.self)
        $0.register(withType: StyleCell.self)
        $0.register(withType: InnerCollectionViewCell.self)
    }
    
    private lazy var rxDataSources = setRxDataSources()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(shimmerView).grow(1)
            $0.addItem(contentView).grow(1).define {
                $0.addItem(titleLabel).marginHorizontal(20).marginTop(11.5).marginBottom(17.5).height(23)
                $0.addItem(collectionView).grow(1)
            }.display(.none)
        }
        
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        
        NotificationCenter.default.rx.notification(.styleClosetTap)
            .compactMap { $0.userInfo }
            .compactMap { $0["selectedCloset"] as? ClosetInfo }
            .bind(with: self) { owner, closetInfo in
                    let detailVM = ClosetDetailViewModel(closetId: closetInfo.closetId, tempId: closetInfo.temperature.tempId)
                    let detailVC = ClosetDetailViewController(detailVM)
                    owner.viewModel.navigationPushViewControllerRelay.accept(detailVC)
                    
            }.disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.bindSectionsRelay
            .bind(to: collectionView.rx.items(dataSource: setRxDataSources()))
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
}

extension StyleViewController {
    
    // MARK: - InnerCV Cell Tap Event
    @objc func pushDetailView(_ notification: Notification) {
        if let data = notification.userInfo as? [String: Any],
            let selectedCloset = data["selectedCloset"] as? ClosetInfo {
            let detailVM = ClosetDetailViewModel(closetId: selectedCloset.closetId, tempId: selectedCloset.temperature.tempId)
            let detailVC = ClosetDetailViewController(detailVM)
            self.viewModel.navigationPushViewControllerRelay.accept(detailVC)
            }
        }
}
    
extension StyleViewController: UICollectionViewDelegate {
    
    // MARK: - DataSource
    func setRxDataSources() ->  RxCollectionViewSectionedAnimatedDataSource<StyleTabSectionModel> {
        RxCollectionViewSectionedAnimatedDataSource<StyleTabSectionModel> (
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            switch item {
            case .banner:
                return collectionView.dequeueCell(withType: BannerCell.self, for: indexPath)
                
            case .type(let innerSectionsArr):
                return collectionView.dequeueCell(withType: InnerCollectionViewCell.self, for: indexPath).then {
//                    $0.delegate = self // 스크롤 중첩이슈 해결을 위한 delegate
                    $0.configure(innerSectionsArr)
                }
                
            default: return UICollectionViewCell()
            }
            
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard self != nil else { return UICollectionReusableView() }
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                switch dataSource[indexPath.section] {
                    
                case .types(let types, _):
                    return collectionView.dequeueReusableHeaderView(withType: StyleTagHeaderView.self, for: indexPath).then {
                        $0.configureTag(types)
                    }
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
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            guard sectionIndex < self.viewModel.bindSectionsRelay.value.count else {
                debugPrint("Section index \(sectionIndex) out of range.")
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
