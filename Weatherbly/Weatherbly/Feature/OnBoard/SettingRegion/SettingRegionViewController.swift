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
    
    private var progressBar = CSProgressView(0.4)
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    private var explanationLabel = CSLabel(.bold, 24, "동네를 설정해주세요")
    
    private let searchImage = UIImageView()
    private var inputRegion = UITextField.neatKeyboard()
    
    private var confirmButton = CSButton(.primary)
    
    private var regionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let textFieldPinHeight = UIScreen.main.bounds.height * 0.177
    private let textFieldMarginHeight = UIScreen.main.bounds.height * 0.33
    private let textFieldWidth = UIScreen.main.bounds.width * 0.85
    private let buttonMarginBottom = UIScreen.main.bounds.height * 0.1
    private let collectionViewHeight = UIScreen.main.bounds.height * 0.59
    
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
            $0.setClearButton(AssetsImage.textClear.image, .whileEditing)
            $0.becomeFirstResponder()
            $0.adjustsFontSizeToFitWidth = true
            $0.delegate = self
        }
        
        confirmButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
        regionCollectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = true
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.showsHorizontalScrollIndicator = false
            $0.register(withType: RegionCollectionViewCell.self)
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
            flex.addItem(regionCollectionView).width(UIScreen.main.bounds.width).height(collectionViewHeight)
        }
        inputRegion.pin.top(textFieldMarginHeight)
        confirmButton.pin.bottom(buttonMarginBottom)
        regionCollectionView.isHidden = true
        
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
        
        regionCollectionView.pin.bottom(12)
        regionCollectionView.isHidden = false
        
        if let text = inputRegion.text {
            explanationLabel.text = "'\(text)' 검색 결과에요"
            view.endEditing(true)
            confirmButton.isHidden = true
            
            viewModel.searchRegion(text)
            
        } else { return }
        
    }
    
    // MARK: Keyboard Action
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                confirmButton.pin.bottom(keyboardSize.height + 30)
                inputRegion.pin.topCenter(to: explanationLabel.anchor.bottomCenter).marginTop(22)
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        inputRegion.pin.top(textFieldMarginHeight)
        confirmButton.pin.bottom(buttonMarginBottom)
    }
}

// MARK: UICollectionViewDelegate
extension SettingRegionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel
            .navigationPushViewControllerRelay
            .accept(viewModel.toCompletViewController(at: indexPath))
    }
}

extension SettingRegionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 30 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 12 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueCell(withType: RegionCollectionViewCell.self, for: indexPath).then {
            $0.configureCellState(RegionCellState.init(region: "경기도"))
            $0.layer.shadowColor = CSColor._0__03.cgColor
        }
    }
}

extension SettingRegionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: regionCollectionView.bounds.width, height: 44)
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
