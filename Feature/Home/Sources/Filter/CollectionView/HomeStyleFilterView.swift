//
//  HomeStyleFilterView.swift
//  Weatherbly
//
//  Created by Khai on 1/5/24.
//

import UIKit
import UIUtil
import WVNetwork
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

public protocol HomeStyleFilterViewDelegate: AnyObject {
    func didTap()
}

public final class HomeStyleFilterView: UICollectionReusableView {
    var bag = DisposeBag()
    
    weak var delegate: HomeStyleFilterViewDelegate?
    
    private var viewState: [CategoryInfo] = []
    
    public lazy var filterList = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout().setFlexibleLayout()
    ).then {
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(withType: HomeStyleFilterCell.self)
    }
    
    public var filterIcon = UIButton()
    
    var buttonTap: Driver<Void> {
        self.filterIcon.rx.tap.asDriver()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    public func configureCellState(state: [CategoryInfo]) {
        viewState = state
        filterList.reloadData()
        
        Task { @MainActor in
            let selectedList = UserDefaultManager.shared.homeStyleFilterList
            guard let index = self.viewState.firstIndex(where: { String($0.id) == selectedList.first }) else { return }
            
            let indexPath = IndexPath(item: index, section: 0)
            self.filterList.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension HomeStyleFilterView {
    private func setLayout() {
        backgroundColor = .white
        
        addSubview(filterList)
        addSubview(filterIcon)
    }
    
    private func layout() {
        filterIcon.pin.vCenter().right(20).size(24)
        filterList.pin.before(of: filterIcon, aligned: .center).left(20).marginRight(20).height(29)
    }
}

// MARK: UICollectionView Layout & DataSource
extension HomeStyleFilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewState.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(
            withType: HomeStyleFilterCell.self,
            for: indexPath
        ).then {
            $0.configureCellState(state: viewState[indexPath.row])
        }
        
        cell.buttonTap
            .drive(with: self, onNext: { owner, _ in
                UserDefaultManager.shared.filteringStyle(id: "\(owner.viewState[indexPath.row].id)")
                owner.delegate?.didTap()
                cell.listButton.isSelected.toggle()
            }).disposed(by: cell.bag)
        
        return cell
    }
}
