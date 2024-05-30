//
//  StyleCell.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/19/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa
import RxDataSources

/// StyleViewController -> StyleCell -> { ItemTagHeaderView ( tagCollectionView + ItemTagCell) + closetCollectionView( HorizonClosetCell ) }

final class StyleCell: UICollectionViewCell {
    
    var bag = DisposeBag()
    
    var typeTitleRelay = BehaviorRelay<ClosetTypeInfo?>(value: ClosetTypeInfo(id: 1,name:"initial value"))
    var sectionModelRelay = PublishRelay<[ClosetSectionModel]>()
    
    var typeTitleLabel = LabelMaker(
        font: UIFont.title_3_B,
        fontColor: UIColor.black,
        alignment: .left
    ).make(text: "#Type1")
    
    var itemTagHeader = ItemTagHeaderView()
    lazy var closetCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 16
        $0.minimumInteritemSpacing = 12
        $0.itemSize = CGSize(width: ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size.width ?? 375) / 3 - 20 , height: 209)
    }
    
    lazy var closetCollectionView = UICollectionView(frame: .zero, collectionViewLayout: closetCollectionFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: HorizonClosetCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellLayout()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        
    }
    
    func cellLayout() {
        
        contentView.flex.height(516).define {
            $0.addItem(typeTitleLabel).marginVertical(16.5)
            $0.addItem(itemTagHeader).width(100%).height(66).backgroundColor(.red)
            $0.addItem(closetCollectionView).height(430)
        }
    }
    
    func binding() {
        typeTitleRelay
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, typeInfo in
                    guard let tag = typeInfo else { return }
                    owner.typeTitleLabel.text = tag.name
                }).disposed(by: bag)
        
        sectionModelRelay
            .bind(to: closetCollectionView.rx.items(dataSource: setRxDataSources()))
            .disposed(by: bag)
    }
    
    public func configure(_ type: ClosetTypeInfo?) {
        guard let type = type else {
            self.typeTitleLabel.text = "# 기본값"
            return }
        
        typeTitleRelay.accept(type)
        
        // TODO: - Test Code
        let mockItemData: [ClosetSectionModel] = [ClosetSectionModel(header: MediumCategoryInfo(id: 1, name: "name 1"), items: [
            StyleClosetInfo(id: 889, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_31111_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 889, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_31110_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 890, name: "개성 더하기", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_31104_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 891, name: "아메카지 감성", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_31056_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 892, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_31055_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 893, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_31054_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 894, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 895, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 896, name: "아메리칸 캐주얼", imageUrl:  "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_36081_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 897, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_32212_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 898, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37134_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active"),
            StyleClosetInfo(id: 899, name: "아메리칸 캐주얼", imageUrl: "https://weathervely.s3.ap-northeast-2.amazonaws.com/image/musinsa_casual_detail_37133_500.jpg", closetStatus: "Active")])]
        
        sectionModelRelay.accept(mockItemData)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        bag = DisposeBag()
        //        binding()
    }
}

extension StyleCell: UICollectionViewDelegateFlowLayout {
    
}
extension StyleCell: UICollectionViewDelegate {
    func setRxDataSources() -> RxCollectionViewSectionedReloadDataSource<ClosetSectionModel> {
        RxCollectionViewSectionedReloadDataSource<ClosetSectionModel> (configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard self != nil else { return UICollectionViewCell() }
            
            return collectionView.dequeueCell(withType: HorizonClosetCell.self, for: indexPath).then {
                $0.configureCell(item)
                
                
            }
            
        })
    }
    
    func setLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            return self?.setClosetLayout()
        }
    }
    // ClosetLayout
    func setClosetLayout() -> NSCollectionLayoutSection {
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .absolute(((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size.width ?? 120) / 3 - 20),
            heightDimension: .absolute(430)
        )
        let item = NSCollectionLayoutItem(layoutSize: cellSize)
        
        /// Group = 한 화면에 들어가는 item을 묶은 단위
        /// https://ios-development.tistory.com/945
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//        group.interItemSpacing = .fixed(16)
        
        
          // 수직 그룹 크기 설정 (세로로 2개의 아이템)
          let verticalGroupSize = NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .fractionalHeight(1.0)
          )
          let verticalGroup = NSCollectionLayoutGroup.vertical(
              layoutSize: verticalGroupSize,
              subitem: item,
              count: 2
          )
        
        // 수평 그룹 크기 설정 (가로로 스크롤)
            let horizontalGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5), // 한 화면에 2개의 그룹
                heightDimension: .fractionalHeight(1.0)
            )
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: horizontalGroupSize,
                subitems: [verticalGroup]
            )
            horizontalGroup.interItemSpacing = .fixed(16)
            
            // 섹션 설정
            let section = NSCollectionLayoutSection(group: horizontalGroup)
        //
        //        // Header
        //        let headerSize = NSCollectionLayoutSize(
        //            widthDimension: .fractionalWidth(1),
        //            heightDimension: .absolute(56)
        //        )
        //
        //        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        //            layoutSize: headerSize,
        //            elementKind: UICollectionView.elementKindSectionHeader,
        //            alignment: .top
        //        )
        //        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        //        sectionHeader.pinToVisibleBounds = true
        
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 10, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        //        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
}
