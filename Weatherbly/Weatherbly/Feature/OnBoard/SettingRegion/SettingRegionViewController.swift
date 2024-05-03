//
//  SettingRegionViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/10.
//

import UIKit
import PinLayout
import FlexLayout
import RxCocoa
import RxSwift
import Then

final class SettingRegionViewController: RxBaseViewController<SettingRegionViewModel> {
    private var titleLabel = LabelMaker(
        font: .title_3_B,
        alignment: .center
    ).make()
    
    private var comment = LabelMaker(
        font: .heading_5_B
    ).make(text: "동네를 설정해 주세요").then {
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var inputRegion = CSTextField().then {
        $0.delegate = self
        $0.setPlaceholder(
            text: "동네 이름(동, 읍, 면)으로 검색",
            font: .body_3_M
        )
        $0.becomeFirstResponder()
    }
    
    private let middleView = UIView()
    
    private lazy var regionTableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.rowHeight = 56
        $0.bounces = false
        $0.showsVerticalScrollIndicator = true
        $0.separatorColor = .gray20
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.register(withType: RegionTableViewCell.self)
    }
    
    private var noResultView = UIView().then {
        $0.addBorders([.top, .bottom], 1, .violet500)
    }
    
    private var noResultInfoView = UIView()
    
    private var noResultImage = UIImageView().then {
        $0.image = .search_empty
    }
    
    private var noResultComment = LabelMaker(
        font: .body_5_M,
        fontColor: .gray50,
        alignment: .center
    ).make(text: "해당하는 동네 정보가 없어요\n동네 이름을 확인해주세요")
    
    private var buttonView = UIView()
    
    private var confirmButton = NewCSButton(.standard, style: .violet600).then {
        $0.setTitle("확인", for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    
    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(titleLabel).marginTop(11.5).width(100%)
            $0.addItem(comment).marginTop(50).marginLeft(20)
            $0.addItem(inputRegion).alignSelf(.stretch).marginTop(32).marginHorizontal(20).height(40)
            $0.addItem(middleView).marginTop(32).marginHorizontal(20).marginBottom(20).grow(1).define {
                $0.addItem(regionTableView).grow(1).display(.none)
                $0.addItem(noResultView).alignItems(.center).justifyContent(.center).grow(1).define {
                    $0.addItem(noResultInfoView).alignItems(.center).define { noResult in
                        noResult.addItem(noResultImage).size(48)
                        noResult.addItem(noResultComment).marginTop(10)
                    }
                }.display(.none)
            }
            $0.addItem(buttonView).position(.absolute).bottom(20).width(100%).height(48).define {
                $0.addItem(confirmButton).marginHorizontal(20).grow(1)
            }
        }
        
        switch viewModel.settingRegionState {
        case .add:
            titleLabel.text = "동네 추가"
        case .change:
            titleLabel.text = "동네 변경"
        case .onboard:
            titleLabel.text = "동네 설정"
        }
    }
    
    override func bind() {
        super.bind()
        
        confirmButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showResult()
            }
            .disposed(by: bag)
        
        inputRegion.rx.text.orEmpty
            .asDriver()
            .drive(with: self) { owner, text in
                if text.count > 1 {
                    owner.confirmButton.isEnabled = true
                } else {
                    owner.confirmButton.isEnabled = false
                }
            }.disposed(by: bag)
        
        viewModel.resultIsEmpty
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isEmpty in
                if isEmpty {
                    owner.regionTableView.flex.display(.none).markDirty()
                    owner.noResultView.flex.display(.flex).markDirty()
                } else {
                    owner.regionTableView.flex.display(.flex).markDirty()
                    owner.noResultView.flex.display(.none).markDirty()
                    owner.regionTableView.reloadData()
                }
                owner.container.flex.layout()
            }.disposed(by: bag)
        
        viewModel.searchedListRelay
            .observe(on: MainScheduler.instance)
            .bind(to: regionTableView.rx.items(
                cellIdentifier: RegionTableViewCell.identifier,
                cellType: RegionTableViewCell.self
            )) { _, data, cell in
                cell.selectionStyle = .none
                cell.configureCellState(data.addressName)
                self.regionTableView.flashScrollIndicators()
            }.disposed(by: bag)
        
        regionTableView.rx.itemSelected
            .bind(with: self) { owner, index in
                owner.viewModel.didTapTableViewCell(at: index)
            }.disposed(by: bag)
    }
    
    private func showResult() {
        if !buttonView.isHidden {
            buttonView.isHidden = true
            unregisterKeyboardNotifications()
            middleView.addBorders([.top, .bottom], 1, .violet500)
        }
        
        if let text = inputRegion.text {
            let attributed = AttributedText.custom(
                originText: "'\(text)' 검색 결과에요",
                targetText: "'\(text)'",
                attributes: [
                    .font: UIFont.heading_5_B,
                    .foregroundColor: UIColor.violet500
                ]
            ).setAttribute
            
            comment.attributedText = attributed
            view.endEditing(true)
            
            viewModel.searchRegion(text)
        } else { return }
    }
}

// MARK: UITextFieldDelegate
extension SettingRegionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /// 백스페이스 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 { return true }
        }
        /// 글자수 제한
        guard let text = textField.text else { return false }
        guard text.count < 10 else { return false }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        showResult()
        return true
    }
}

// MARK: Keyboard Action
extension SettingRegionViewController {
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !buttonView.isHidden {
                buttonView.flex.bottom(keyboardSize.height)
                container.flex.layout()
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        if !buttonView.isHidden {
            buttonView.flex.bottom(20)
            container.flex.layout()
        }
    }
}
