//
//  ThemeTitleHeaderView.swift
//  Weatherbly
//
//  Created by 최수훈 on 2/21/24.
//

import UIKit
import RxSwift
import FlexLayout
import PinLayout
import Then
import RxCocoa

protocol TypeTagDelegate: AnyObject {
    func typeTagDidTap()
}


public class StyleTagHeaderView: UICollectionReusableView {
    
    weak var delegate: TypeTagDelegate?
    var bag = DisposeBag()
    var tags: [ClosetTypeInfo] = []
    var tagsRelay = BehaviorRelay<[ClosetTypeInfo]?>(value: [])
    
    lazy var tagCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
    }
    
    public lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagCollectionFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: TypeTagCell.self)
        $0.dataSource = self
        $0.delegate = self
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
        self.flex.layout()
    }
    
    func layout() {
        self.flex.addItem(tagCollectionView).width(100%).height(56).direction(.row)
    }
    
    func binding() {
        
        
        
    }
    
    func configureTag(_ tagItem: [ClosetTypeInfo]?) {
        guard let tagItem = tagItem else { return }
        tagsRelay.accept(tagItem)
        tagCollectionView.reloadData()
    }
    
}

extension StyleTagHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tags = tagsRelay.value, !tags.isEmpty else { return 0 }
        return tags.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueCell(withType: TypeTagCell.self, for: indexPath).then {
            $0.configure(typeInfo: tagsRelay.value?[indexPath.item] ?? ClosetTypeInfo(id: 0, name: "tag"))
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel().then {
            $0.font = UIFont.body_5_B
            $0.setLineHeight(UIFont.body_5_B.lineHeight)
            $0.text = tagsRelay.value?[indexPath.item].name ?? ""
            $0.sizeToFit()
        }
        
        let size = label.frame.size
        return CGSize(width: size.width + 28, height: size.height + 12)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("didTap : \(indexPath)")
//        self.touchEventDelegate?.selectItemTags(self, didSelectItemAt: indexPath.item)
    }
}
