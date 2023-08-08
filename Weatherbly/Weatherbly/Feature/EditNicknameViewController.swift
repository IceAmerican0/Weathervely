//
//  EditNicknameViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/09.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class EditNicknameViewController: RxBaseViewController<EditNicknameViewModel> {
    
    private var leftButtonDidTapRelay = PublishRelay<Void>()
    private var csNavigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    
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
    private let nicknameTextField = UITextField()
    
    private let genderLableView = UIView()
    private let genderTitleLabel = UILabel()
    private let genderLabel = UILabel()
    
    private var bottomButton = CSButton(.primary)
    
    private let buttonWrapper = UIView()
    private let womanButton = UIButton()
    private let manButton = UIButton()
    
    private let imageHeight = UIScreen.main.bounds.height * 0.34
    
    typealias editMode = UITextField.editMode
    var displayMode: editMode = .justShow
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
            $0.backgroundColor = .clear
        }
        
        nicknameTextField.do {
            $0.font = .systemFont(ofSize: 20)
            $0.text = "\(UserDefaultManager.shared.nickname)"
            $0.isEnabled = false
        }
        
        genderLableView.do {
            $0.addBorder(.bottom)
        }
        
        genderTitleLabel.do {
            $0.text = "성별"
            $0.font = .systemFont(ofSize: 20, weight: .medium)
            $0.addBorder(.right, 3)
        }
        
        genderLabel.do {
            $0.font = .systemFont(ofSize: 20)
            $0.text = "여성"
            $0.textAlignment = .natural
        }
        
        bottomButton.do {
            $0.setTitle("수정하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
        womanButton.do {
            $0.setTitle("여성", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.backgroundColor = CSColor._248_248_248.color
            $0.layer.cornerRadius = 13
        }
        
        manButton.do {
            $0.setTitle("남성", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.backgroundColor = CSColor._248_248_248.color
            $0.layer.cornerRadius = 13
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
                        
                                flex.addItem(genderLableView)
                                    .marginHorizontal(22)
                                    .direction(.row)
                                    .define { flex in
                                        flex.addItem(genderTitleLabel)
                                            .marginVertical(14)
                                            .width(67)
                                            .marginLeft(26)
                                        flex.addItem(genderLabel)
                                            .view?.pin.left(to: genderTitleLabel.edge.right).right(to: genderLableView.edge.right)
                                            .marginLeft(18)
                                    }
                        
                        flex.addItem(bottomButton)
                            .marginHorizontal(43)
                            .height(bottomButton.primaryHeight)
                            .marginTop(UIScreen.main.bounds.height * 0.44)

//                        bottomButton.pin.bottom(to: contentWrapper.edge.bottom).marginBottom(10)
                    }
            }
    }
    
    override func bind() {
        super.bind()
        
        csNavigationView.leftButtonDidTapRelay
            .bind(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    
        
        bottomButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didTapCorrectionButton()
//                guard let displayMode = self?.viewModel.bottomButtonDidTap() else {
//                    return
//                }
//                self?.nicknameTextField.setEditMode(displayMode)
//                self?.genderLabel.setEditMode(displayMode)
//                UIView.animate(withDuration: 0.5) {
//                    self?.layout()
//                }
//                self?.nicknameTextField.becomeFirstResponder()
//                self?.nicknameTextFieldWrapper.backgroundColor = CSColor._248_248_248.color
            })
            .disposed(by: bag)
    }
    
}
