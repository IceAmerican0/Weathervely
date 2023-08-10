//
//  EditRegionViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/12.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final class EditRegionViewController: RxBaseViewController<EditRegionViewModel> {
    
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    
    private let contentWrapper = UIView()
    private let outlineImage = UIImageView()
    private let subtitleLabel = CSLabel(.bold, 18, "즐겨 찾는 동네 (최대 3개)")
    private var favoriteTableView = UITableView()
    private var confirmButton = CSButton(.primary)
    
    private let textFieldMarginHeight = UIScreen.main.bounds.height * 0.186
    private let tableViewWidth = UIScreen.main.bounds.width * 0.864
    private let buttonMarginBottom = UIScreen.main.bounds.height * 0.1
    
    private var listCount = 0
    
    override func attribute() {
        super.attribute()
        
        navigationView.do {
            $0.setTitle("동네 설정")
            $0.addBorder(.bottom)
        }
        
        outlineImage.do {
            $0.setAssetsImage(AssetsImage.rightArrow)
        }
        
        favoriteTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = false
            $0.backgroundColor = CSColor._253_253_253.color
            $0.layer.cornerRadius = 5
            $0.register(EditRegionTableViewCell.self, forCellReuseIdentifier: EditRegionTableViewCell.identifier)
        }
        
        confirmButton.do {
            $0.setTitle("동네 추가하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define { flex in
            flex.addItem(navigationView).width(UIScreen.main.bounds.width)
            flex.addItem(contentWrapper).direction(.row).alignItems(.center).marginLeft(21).marginTop(64).define { flex in
                flex.addItem(outlineImage).size(24)
                flex.addItem(subtitleLabel).marginLeft(3).height(28)
            }
            flex.addItem(confirmButton).width(88%).height(62)
            flex.addItem(favoriteTableView).marginTop(8).marginHorizontal(24).height(168)
        }
        
        confirmButton.pin.hCenter().bottom(buttonMarginBottom)
    }
    
    override func viewBinding() {
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(onNext: viewModel.didTapConfirmButton)
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        viewModel.loadRegionList()
        
        viewModel.loadedListRelay
            .subscribe(onNext: { [weak self] _ in
                self?.listCount = self?.viewModel.loadedListRelay.value.count ?? 0
                self?.confirmButtonState()
                self?.favoriteTableView.reloadData()
            })
            .disposed(by: bag)
    }
    
    private func confirmButtonState() {
        confirmButton.do {
            if listCount == 3 {
                $0.isEnabled = false
                $0.setButtonStyle(.grayFilled)
            } else {
                $0.isEnabled = true
                $0.setButtonStyle(.primary)
            }
        }
    }
}

// MARK: UITableViewDelegate
extension EditRegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 56 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 25 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapTableViewCell(indexPath)
    }
    
}

extension EditRegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(withType: EditRegionTableViewCell.self, for: indexPath).then {
            guard let regionName = viewModel.loadedListRelay.value[indexPath.row].address_name else { return }
            $0.configureCellState(EditRegionCellState(region: regionName, count: listCount))
        }
    }
}
