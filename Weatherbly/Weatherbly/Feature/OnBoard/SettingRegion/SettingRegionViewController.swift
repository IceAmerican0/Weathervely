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
import RxRelay

final class SettingRegionViewController: RxBaseViewController<EmptyViewModel> {
    
    private var progressBar = CSProgressView(0.4)
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private var explanationLabel = CSLabel(.bold, 24, "동네를 설정해주세요")
    
    private let inputWrapper = UIView()
    private let searchImage = UIImageView()
    private var inputRegion = UITextField()
    private let cancelButton = UIButton()
    
    private var confirmButton = CSButton(.primary)
    private var regionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private let textFieldMarginHeight = UIScreen.main.bounds.height * 0.33
    private let textFieldWidth = UIScreen.main.bounds.width * 0.63
    private let buttonMarginBottom = UIScreen.main.bounds.height * 0.1
    
    var isFromEdit = false
    
    let navigationLeftButtonDidTapRelay = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputRegion.becomeFirstResponder()
        
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
        
        inputWrapper.do {
            $0.backgroundColor = CSColor._220_220_220.color
            $0.layer.cornerRadius = 13
        }
        
        searchImage.do {
            $0.setAssetsImage(AssetsImage.search)
        }
        
        inputRegion.do {
            $0.delegate = self
            $0.placeholder = "동네 이름(동, 읍, 면)으로 검색"
            $0.textAlignment = .center
        }
        
        
        cancelButton.do {
            $0.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        }
        
        regionCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = true

            $0.backgroundColor = CSColor._220_220_220.color
            $0.layer.cornerRadius = 5
            $0.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(progressBar)
            flex.addItem(navigationView).width(UIScreen.main.bounds.width)
            flex.addItem(explanationLabel).marginTop(27)
            flex.addItem(inputWrapper).direction(.row).alignItems(.center)
                .marginHorizontal(30)
                .define { flex in
                flex.addItem(searchImage).size(26)
                flex.addItem(inputRegion).width(textFieldWidth).height(50)
                flex.addItem(cancelButton).size(44)
            }
            flex.addItem(confirmButton).width(88%).height(62)
            flex.addItem().width(UIScreen.main.bounds.width).height(300)
        }
        inputWrapper.pin.top(textFieldMarginHeight)
        confirmButton.pin.bottom(buttonMarginBottom)
        
        if isFromEdit {
            progressBar.isHidden = true
            navigationView.setTitle("동네 변경 / 추가")

            explanationLabel.isHidden = true
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        navigationView
            .leftButtonDidTapRelay
            .bind(to: viewModel.navigationPopViewControllerRelay)
            .disposed(by: bag)
                
    }
    
    @objc private func didTapCancel() {
        inputRegion.text = ""
    }
    
    @objc private func didTapConfirm() {
        showResult()
    }
    
    private func showResult() {
        inputWrapper.pin.topCenter(to: explanationLabel.anchor.bottomCenter).marginTop(22)
        
        if let text = inputRegion.text {
            explanationLabel.text = "'\(text)' 검색 결과에요"
            view.endEditing(true)
            unregisterKeyboardNotifications()
            confirmButton.hide()
        } else { return }
        
//        view.setNeedsLayout()
    }
    
    // MARK: Keyboard Action
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                confirmButton.pin.bottom(buttonMarginBottom + keyboardSize.height)
                inputWrapper.pin.topCenter(to: explanationLabel.anchor.bottomCenter).marginTop(22)
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        inputWrapper.pin.top(textFieldMarginHeight)
        confirmButton.pin.bottom(buttonMarginBottom)
    }
}

// MARK: UICollectionViewDelegate
extension SettingRegionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    
}

extension SettingRegionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 30 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueCell(withType: RegionCollectionViewCell.self, for: indexPath).then {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        string != " "
    }
}
