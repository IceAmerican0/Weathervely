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

final class SettingRegionViewController: RxBaseViewController<SettingRegionViewModel> {
    
    private var progressBar = CSProgressView(0.66)
    private var navigationView = CSNavigationView(.leftButton(.navi_back))
    private var explanationLabel = CSLabel(.bold, 24, "동네를 설정해주세요")
    
    private let searchImage = UIImageView()
    private var inputRegion = UITextField.neatKeyboard()
    
    private var confirmButton = CSButton(.grayFilled)
    private var regionTableView = UITableView()
    
    private let tableViewMarginTop = UIScreen.main.bounds.height * 0.06
    private let tableViewHeight = UIScreen.main.bounds.height * 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        
        // TODO: 배경 터치했을때 키보드 내림 / 테이블뷰와 터치 겹치는 현상 수정
//        gestureEndEditing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    override func attribute() {
        super.attribute()
        
        explanationLabel.do {
            $0.backgroundColor = .white
            $0.adjustsFontSizeToFitWidth = true
        }
        
        navigationView.do {
            $0.isHidden = true
        }
        
        searchImage.do {
            $0.setAssetsImage(AssetsImage.search)
        }
        
        inputRegion.do {
            $0.backgroundColor = CSColor._248_248_248.color
            $0.layer.cornerRadius = 13
            $0.delegate = self
            $0.placeholder = "동네 이름(동,읍,면)으로 검색"
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 20)
            $0.setClearButton(AssetsImage.delete.image, .whileEditing)
            $0.becomeFirstResponder()
            $0.adjustsFontSizeToFitWidth = true
            $0.delegate = self
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.isEnabled = false
        }
        
        regionTableView.do {
            $0.delegate = self
            $0.rowHeight = 56
            $0.isScrollEnabled = true
            $0.bounces = false
            $0.showsVerticalScrollIndicator = true
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.showsHorizontalScrollIndicator = false
            $0.register(withType: RegionTableViewCell.self)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView).width(100%)
            flex.addItem(explanationLabel).marginTop(27).marginHorizontal(35).width(85%).height(34)
            flex.addItem(inputRegion).marginTop(22).marginHorizontal(30).width(85%).height(50)
            flex.addItem(regionTableView).marginTop(tableViewMarginTop).marginHorizontal(30).height(tableViewHeight)
            flex.addItem(confirmButton).position(.absolute).bottom(10%).marginHorizontal(43).width(78%).height(62)
        }
        regionTableView.isHidden = true
        
        if viewModel.settingRegionState != .onboard {
            progressBar.isHidden = true
            navigationView.isHidden = false
            navigationView.setTitle("동네 변경 / 추가")
            navigationView.addBorder(.bottom)
            explanationLabel.isHidden = true
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showResult()
            }
            .disposed(by: bag)
        
        inputRegion.rx.text.orEmpty
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, text in
                    if text.count > 1 {
                        owner.confirmButton.isEnabled = true
                        owner.confirmButton.setButtonStyle(.primary)
                    } else {
                        owner.confirmButton.isEnabled = false
                        owner.confirmButton.setButtonStyle(.grayFilled)
                    }
            })
            .disposed(by: bag)
    }
    
    override func viewModelBinding() {
        super.viewModelBinding()
        
        viewModel.searchedListRelay
            .bind(to: regionTableView.rx
                .items(cellIdentifier: RegionTableViewCell.identifier,
                       cellType: RegionTableViewCell.self)) { _, data, cell in
                cell.configureCellState(data.addressName)
                self.regionTableView.flashScrollIndicators()
            }
            .disposed(by: bag)
    }
    
    private func showResult() {
        unregisterKeyboardNotifications()
        
        regionTableView.isHidden = false
        
        if let text = inputRegion.text {
            explanationLabel.text = "'\(text)' 검색 결과에요"
            view.endEditing(true)
            confirmButton.isHidden = true
            
            viewModel.searchRegion(text)
        } else { return }
    }
}

// MARK: UITableViewDelegate
extension SettingRegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        cell?.isSelected = true
        viewModel.didTapTableViewCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .default
        cell?.isSelected = false
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
            confirmButton.pin.bottom(keyboardSize.height + 30)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        confirmButton.pin.bottom(10%)
    }
}
