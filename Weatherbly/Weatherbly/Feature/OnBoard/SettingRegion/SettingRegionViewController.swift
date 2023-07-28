//
//  SettingRegionViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/10.
//

import UIKit
import PinLayout
import FlexLayout
import RxSwift

final class SettingRegionViewController: RxBaseViewController<SettingRegionViewModel> {
    
    private var progressBar = CSProgressView(0.5)
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private var explanationLabel = CSLabel(.bold, 24, "동네를 설정해주세요")
    
    private let searchImage = UIImageView()
    private var inputRegion = UITextField.neatKeyboard()
    
    private var confirmButton = CSButton(.primary)
    
    private var regionTableView = UITableView()
    
    private let textFieldPinHeight = UIScreen.main.bounds.height * 0.177
    private let textFieldMarginHeight = UIScreen.main.bounds.height * 0.33
    private let textFieldWidth = UIScreen.main.bounds.width * 0.85
    private let buttonMarginBottom = UIScreen.main.bounds.height * 0.1
    private let tableViewHeight = UIScreen.main.bounds.height * 0.59
    
    var isFromEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerKeyboardNotifications()
        gestureEndEditing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    override func attribute() {
        super.attribute()
        
        explanationLabel.do {
            $0.backgroundColor = .white
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
        }
        
        regionTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = true
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.showsHorizontalScrollIndicator = false
            $0.register(withType: RegionTableViewCell.self)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView).width(UIScreen.main.bounds.width)
            flex.addItem(explanationLabel).marginTop(27)
            flex.addItem(inputRegion).marginHorizontal(30).width(textFieldWidth).height(50)
            flex.addItem(confirmButton).width(88%).height(62)
            flex.addItem(regionTableView).marginHorizontal(30).height(tableViewHeight)
        }
        inputRegion.pin.top(textFieldMarginHeight)
        confirmButton.pin.bottom(buttonMarginBottom)
        regionTableView.isHidden = true
        
        if isFromEdit {
            progressBar.isHidden = true
            navigationView.setTitle("동네 변경 / 추가")

            explanationLabel.isHidden = true
        }
    }
    
    override func viewBinding() {
        navigationView.leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(onNext: showResult)
            .disposed(by: bag)
    }
    
    private func showResult() {
        unregisterKeyboardNotifications()
        inputRegion.pin.top(textFieldPinHeight)
        
        regionTableView.pin.bottom(12)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 56 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapTableViewCell(at: indexPath)
    }
}

extension SettingRegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
//        viewModel.searchedListRelay.value[0].documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueCell(withType: RegionTableViewCell.self, for: indexPath).then {
            $0.configureCellState("서울특별시")
//            $0.configureCellState(viewModel.setRegionName(at: indexPath))
            $0.layer.shadowColor = CSColor._0__03.cgColor
        }
    }
}

// MARK: UITextFieldDelegate
extension SettingRegionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        showResult()
        return true
    }
}

// MARK: Keyboard Action
extension SettingRegionViewController {
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            inputRegion.pin.top(to: explanationLabel.edge.bottom).marginTop(22)
            confirmButton.pin.bottom(keyboardSize.height + 30)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        inputRegion.pin.top(textFieldMarginHeight)
        confirmButton.pin.bottom(buttonMarginBottom)
    }
}
