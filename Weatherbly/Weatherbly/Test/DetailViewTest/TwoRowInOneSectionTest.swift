//
//  TwoRowInOneSectionTest.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/19/24.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa


enum SectionModelItemTest {
    case typeA(TypeA)
    case typeB(TypeB)
}

struct TypeA {
    let title: String
}

struct TypeB {
    let detail: String
}

struct SectionModel {
    var header: String
    var items: [Item]
}

extension SectionModel: SectionModelType {
    typealias Item = SectionModelItemTest

    init(original: SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}


class TypeACell: UICollectionViewCell {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with item: TypeA) {
        titleLabel.text = item.title
    }
}

class TypeBCell: UICollectionViewCell {
    let detailLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with item: TypeB) {
        detailLabel.text = item.detail
    }
}
// 뷰 컨트롤러 정의
class TwoRowInOneSectionTest: UIViewController {
    var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel>(
        configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .typeA(let typeAItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeACell", for: indexPath) as! TypeACell
                cell.configure(with: typeAItem)
                cell.backgroundColor = .red
                return cell
            case .typeB(let typeBItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeBCell", for: indexPath) as! TypeBCell
                cell.configure(with: typeBItem)
                cell.backgroundColor = .blue
                return cell
            }
        }
    )
    
    let typeAItems = (1...100).map { SectionModelItemTest.typeA(TypeA(title: "Title \($0)")) }
    let typeBItems = (1...100).map { SectionModelItemTest.typeB(TypeB(detail: "Detail \($0)")) }
   
    let sections: [SectionModel] = [
        SectionModel(header: "Section 1", items: (1...100).map { SectionModelItemTest.typeA(TypeA(title: "Title \($0)")) }),
        SectionModel(header: "Section 1", items: (1...100).map { SectionModelItemTest.typeB(TypeB(detail: "Detail \($0)")) })
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // 컬렉션 뷰 설정
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return self.createLayout(sectionIndex: sectionIndex)
        }
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(TypeACell.self, forCellWithReuseIdentifier: "TypeACell")
        collectionView.register(TypeBCell.self, forCellWithReuseIdentifier: "TypeBCell")

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // 데이터 바인딩
        Observable.just(sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func createLayout(sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemWidth = (Constants.screenWidth - 20 ) / 3
        let groupWidth = itemWidth * 3 + 32
        // Type A 아이템 레이아웃
        let typeAItemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(150))
        let typeAItem = NSCollectionLayoutItem(layoutSize: typeAItemSize)

        let typeAGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(150))
        let typeAGroup = NSCollectionLayoutGroup.horizontal(layoutSize: typeAGroupSize, subitems: [typeAItem])

        typeAGroup.interItemSpacing = .fixed(16)
        // Type B 아이템 레이아웃
        let typeBItemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth), heightDimension: .absolute(150))
        let typeBItem = NSCollectionLayoutItem(layoutSize: typeBItemSize)

        let typeBGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth), heightDimension: .absolute(150))
        let typeBGroup = NSCollectionLayoutGroup.horizontal(layoutSize: typeBGroupSize, subitems: [typeBItem])
        typeBGroup.interItemSpacing = .fixed(16)
        // 전체 섹션 레이아웃
        let section = NSCollectionLayoutSection(group: sectionIndex % 2 == 0 ? typeAGroup : typeBGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
        section.interGroupSpacing = 16
        return section
    }
    
//    func createLayout(sectionIndex: Int) -> NSCollectionLayoutSection {
//            // Type A 아이템 레이아웃
//            let typeAItemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(150))
//            let typeAItem = NSCollectionLayoutItem(layoutSize: typeAItemSize)
//
//            let typeAGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .absolute(150))
//            let typeAGroup = NSCollectionLayoutGroup.horizontal(layoutSize: typeAGroupSize, subitems: [typeAItem])
//
//            // Type B 아이템 레이아웃
//            let typeBItemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(150))
//            let typeBItem = NSCollectionLayoutItem(layoutSize: typeBItemSize)
//
//            let typeBGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .absolute(150))
//            let typeBGroup = NSCollectionLayoutGroup.horizontal(layoutSize: typeBGroupSize, subitems: [typeBItem])
//
//            // 최종 섹션 레이아웃 생성
//            let sectionLayout = NSCollectionLayoutSection(group: typeAGroup)
//            sectionLayout.orthogonalScrollingBehavior = .continuous
//            sectionLayout.boundarySupplementaryItems = [
//                NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
//                    elementKind: UICollectionView.elementKindSectionHeader,
//                    alignment: .top)
//            ]
//            sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
//
//            return sectionLayout
//        }

}
