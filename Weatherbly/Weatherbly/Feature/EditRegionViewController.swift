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
import Then

final class EditRegionViewController: RxBaseViewController<EditRegionViewModel> {
    private var navigationView = CSNavigationView(.leftButton(.leftArrow_black)).then {
        $0.setTitle("동네 설정")
        $0.addBorder(.bottom)
    }
    
    private let header = LabelMaker(
        font: .body_3_M,
        fontColor: .gray200
    ).make(text: "즐겨 찾는 동네 (최대 3개)")
    
    private lazy var favoriteTableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.delegate = self
        $0.rowHeight = 84
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.register(EditRegionTableViewCell.self, forCellReuseIdentifier: EditRegionTableViewCell.identifier)
    }
    
    private var confirmButton = NewCSButton(.standard, style: .violet600).then {
        $0.setTitle("동네 추가하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private var listCount = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.pin.top(view.pin.safeArea.top).horizontally().bottom()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.backgroundColor(.violet10).define {
            $0.addItem(navigationView).width(UIScreen.main.bounds.width)
            $0.addItem(header).marginTop(22).marginLeft(20)
            $0.addItem().grow(1).define {
                $0.addItem(favoriteTableView).marginTop(13).marginHorizontal(20).grow(1)
                $0.addItem().position(.absolute).bottom(20).width(100%).height(48).define {
                    $0.addItem(confirmButton).marginHorizontal(20).grow(1)
                }
            }
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.navigationPopViewControllerRelay.accept(Void())
            }).disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with:self) { owner, _ in
                owner.viewModel.didTapConfirmButton()
            }
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.loadedListRelay
            .bind(to: favoriteTableView.rx
                .items(cellIdentifier: EditRegionTableViewCell.identifier,
                       cellType: EditRegionTableViewCell.self)) { row, data, cell in
                self.listCount = self.viewModel.loadedListRelay.value.count
                
                cell.selectionStyle = .none
                cell.configureCellState(EditRegionCellState(region: data.addressName, count: self.listCount))
                cell.buttonTap
                    .drive(
                        with: self,
                        onNext: { owner, _ in
                            owner.viewModel.didTapCellButton(row)
                            cell.button.isSelected = false
                            cell.button.isHighlighted = false
                        }
                    ).disposed(by: cell.bag)
                
                self.confirmButtonState()
            }
            .disposed(by: bag)
    }
    
    private func confirmButtonState() {
        confirmButton.do {
            if listCount == 3 {
                $0.isEnabled = false
            } else {
                $0.isEnabled = true
            }
        }
    }
}

// MARK: UITableViewDelegate
extension EditRegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateMainRegion(indexPath.row)
    }
}
