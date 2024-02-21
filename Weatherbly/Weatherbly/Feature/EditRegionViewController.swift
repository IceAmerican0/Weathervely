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
    
    private var navigationView = CSNavigationView(.leftButton(.navi_back))
    
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
            $0.rowHeight = 56
            $0.isScrollEnabled = false
            $0.bounces = false
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
            flex.addItem(favoriteTableView).marginTop(8).marginHorizontal(24).height(168)
            flex.addItem(confirmButton).position(.absolute).alignSelf(.center).bottom(buttonMarginBottom).width(88%).height(62)
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .bind(with: self) { owner, _ in
                if let viewControllers = owner.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if let settingViewController = viewController as? SettingViewController {
                            owner.navigationController?.popToViewController(settingViewController, animated: true)
                            break
                        }
                    }
                    
                    owner.viewModel.navigationPoptoRootRelay.accept(Void())
                }
            }
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with:self) { owner, _ in
                owner.viewModel.didTapConfirmButton()
            }
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.loadRegionList()
        
        viewModel.loadedListRelay
            .bind(to: favoriteTableView.rx
                .items(cellIdentifier: EditRegionTableViewCell.identifier,
                       cellType: EditRegionTableViewCell.self)) { row, data, cell in
                self.listCount = self.viewModel.loadedListRelay.value.count
                
                if row == 0 {
                    cell.backgroundColor = CSColor._248_248_248.color
                } else {
                    cell.backgroundColor = .white
                }
                
                cell.configureCellState(EditRegionCellState(region: data.addressName, count: self.listCount), row)
                cell.buttonTapAction { [weak self] index in
                    self?.viewModel.didTapCellButton(index)
                }
                
                self.confirmButtonState()
            }
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 25 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        cell?.isSelected = true
        viewModel.updateMainRegion(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .default
        cell?.isSelected = false
    }
}
