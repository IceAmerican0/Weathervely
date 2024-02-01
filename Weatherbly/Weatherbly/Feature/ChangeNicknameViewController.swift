//
//  ChangeNicknameViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/12.
//

import UIKit
import FlexLayout
import PinLayout
import RxCocoa
import RxSwift

class ChangeNicknameViewController: RxBaseViewController<ChangeNicknameViewModel> {
    
    private var leftButtonDidTapRelay = PublishRelay<Void>()
    private var csNavigationView = CSNavigationView(.leftButton(.navi_back))
    
    private let contentWrapper = UIView()
    
    private let subTitleView = UIView()
    private let rightArrowImage = UIImageView()
    private let subTitleLabel = UILabel()
    private let nicknameLableView = UIView()
    private let nicknameTitleLable = UILabel()
    // TODO: -
    /// CSLabel의 방식을 생각해볼 필요가 있다
    /// API 를 통해서 가지고오는 데이터를 가지고 라벨을 세팅해야한다면, init 시점에서 가지고 올 수 있는 데이터가 없기 때문에 에러가 걸릴것...
    /// 따라서 CSLabel을 커스텀하기 보다 CSStyle의 폰트를 컴포넌트화 하는 것이 더 올발라 보인다..
//    private let nicknameTextField = CSLabel(.regular,20, "닉네임")
    private let nicknameTextFieldWrapper = UIView()
    private let nicknameTextField = UITextField.neatKeyboard()
    
    private let genderLableView = UIView()
    private let genderTitleLabel = UILabel()
    
    private var bottomButton = CSButton(.primary)
    
    private let buttonWrapper = UIView()
    private let womanButton = UIButton()
    private let manButton = UIButton()
    
    private let imageHeight = UIScreen.main.bounds.height * 0.34
    
    typealias editMode = UITextField.editMode
    var displayMode: editMode = .justShow
    
    private var isFemale = UserDefaultManager.shared.isFemale
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    override func attribute() {
        super.attribute()
        
        csNavigationView.do {
            $0.setTitle("개인 설정")
            $0.addBorder(.bottom)
        }
        
        subTitleView.do {
            $0.addBorder(.bottom)
        }
        
        rightArrowImage.do {
            $0.image = AssetsImage.rightArrow.image
            $0.contentMode = .scaleAspectFit
        }
        
        subTitleLabel.do {
            $0.text = "개인 정보"
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.textColor = UIColor(r: 78, g: 78, b: 78)
        }
        
        nicknameLableView.do {
            $0.addBorder(.bottom)
        }
        
        nicknameTitleLable.do {
            $0.text = "닉네임"
            $0.font = .systemFont(ofSize: 20, weight: .medium)
            $0.addBorder(.right, 3)
        }
        
        nicknameTextFieldWrapper.do {
            $0.layer.cornerRadius = 5
            $0.backgroundColor = CSColor._248_248_248.color
        }
        
        nicknameTextField.do {
            $0.font = .systemFont(ofSize: 20)
            $0.text = UserDefaultManager.shared.nickname
            $0.setClearButton(AssetsImage.delete.image, .whileEditing)
            $0.becomeFirstResponder()
            $0.delegate = self
        }
        
        genderLableView.do {
            $0.addBorder(.bottom)
        }
        
        genderTitleLabel.do {
            $0.text = "성별"
            $0.font = .systemFont(ofSize: 20, weight: .medium)
            $0.addBorder(.right, 3)
        }
        
        womanButton.do {
            $0.setTitle("여성", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(.white, for: .selected)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 13
            $0.isSelected = isFemale ? true : false
        }
        
        manButton.do {
            $0.setTitle("남성", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(.white, for: .selected)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 13
            $0.isSelected = isFemale ? false : true
        }
        
        setButtonColor()
        
        bottomButton.do {
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.justifyContent(.spaceBetween)
            .define { flex in
                flex.addItem(csNavigationView)
                
                flex.addItem(contentWrapper)
                    .grow(1)
                    .shrink(1)
                    .define { flex in
                        flex.addItem(subTitleView)
                            .marginTop(55)
                            .paddingVertical(9)
                            .marginHorizontal(22)
                            .direction(.row)
                            .define { flex in
                                flex.addItem(rightArrowImage)
                                flex.addItem(subTitleLabel)
                            }
                        
                        flex.addItem(nicknameLableView)
                            .marginHorizontal(22)
                            .direction(.row)
                            .define { flex in
                                flex.addItem(nicknameTitleLable)
                                    .marginVertical(14)
                                    .width(67)
                                    .marginLeft(26)
                                    
                                flex.addItem(nicknameTextFieldWrapper)
                                    .marginVertical(7)
                                    .marginRight(2)
                                    .marginLeft(12)
                                    .grow(1)
                                    .shrink(1)
                                    .define { flex in
                                        flex.addItem(nicknameTextField)
                                            .marginHorizontal(6)
                                            .marginVertical(7)
                                    }
                            }
                        
//                        flex.addItem(genderLableView)
//                            .marginHorizontal(22)
//                            .direction(.row)
//                            .define { flex in
//                                flex.addItem(genderTitleLabel)
//                                    .marginVertical(14)
//                                    .width(67)
//                                    .marginLeft(26)
//
//                                flex.addItem(buttonWrapper)
//                                    .marginVertical(9)
//                                    .marginLeft(18)
//                                    .grow(0.5)
//                                    .shrink(0.5)
//                                    .direction(.row)
//                                    .define { flex in
//                                    flex.addItem(womanButton)
//                                            .padding(10)
//                                            .right(7)
//                                            .grow(1).shrink(1)
//
//                                    flex.addItem(manButton)
//                                            .padding(10)
//                                            .left(7)
//                                            .grow(1).shrink(1)
//                                }
//                            }
            }
            flex.addItem(bottomButton)
                .position(.absolute)
                .bottom(10%)
                .marginHorizontal(43)
                .width(78%)
                .height(bottomButton.primaryHeight)
        }
    }
    
    override func bind() {
        super.bind()
        
        csNavigationView.leftButtonDidTapRelay
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: bag)
        
        womanButton.rx.tap
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    if owner.isFemale == false { owner.buttonToggle() }
            })
            .disposed(by: bag)
        
        manButton.rx.tap
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, _ in
                    if owner.isFemale == true { owner.buttonToggle() }
            })
            .disposed(by: bag)
        
        bottomButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let inputNickname = owner.nicknameTextField.text else { return }
                owner.viewModel.didTapConfirmButton(UserInfoRequest(nickname: inputNickname/*,
                                                                    gender: owner.isFemale == true ? "female" : "male"*/))
            }.disposed(by: bag)
        
        nicknameTextField.rx.text.orEmpty
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, text in
                    if text.count > 1 {
                        owner.bottomButton.isEnabled = true
                        owner.bottomButton.setButtonStyle(.primary)
                    } else {
                        owner.bottomButton.isEnabled = false
                        owner.bottomButton.setButtonStyle(.grayFilled)
                    }
            })
            .disposed(by: bag)
    }
    
    private func buttonToggle() {
        womanButton.isSelected.toggle()
        manButton.isSelected.toggle()
        isFemale = womanButton.isSelected
        setButtonColor()
    }
    
    private func setButtonColor() {
        womanButton.backgroundColor = isFemale ? CSColor._151_151_151.color : CSColor._248_248_248.color
        manButton.backgroundColor = isFemale ? CSColor._248_248_248.color : CSColor._151_151_151.color
    }
}

// MARK: UITextFieldDelegate
extension ChangeNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        customTextField(textField, range, string)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Keyboard Action
extension ChangeNicknameViewController {
    override func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomButton.pin.bottom(keyboardSize.height + 30)
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        bottomButton.pin.bottom(10%)
    }
}
