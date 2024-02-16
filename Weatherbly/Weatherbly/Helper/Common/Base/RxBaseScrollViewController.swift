//
//  RxBaseScrollViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 1/27/24.
//
import UIKit
import RxSwift
import Then
import FlexLayout
import PinLayout

public class RxBaseScrollViewController<ViewModel>: UIViewController, CodeBaseInitializerProtocol, BaseDisposebag where ViewModel: RxBaseViewModel {
    
    lazy var bag: DisposeBag = {
        self.viewModel.bag
    }()
    
    var viewModel: ViewModel
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    // MARK: - Initialize

    init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        /// attribute, layout, bind 를 호출해서 필요한 코드를 작성하면 된다.
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    /// child component들의 속성을 잡아주기 위해서 flex.layout()을 먼저 호출한다.
        scrollView.pin.all(view.pin.safeArea)
        
        contentView.pin.all()
        
        contentView.flex.layout(mode: .adjustHeight)
        
        // frame과 bound의 차이
        /// https://babbab2.tistory.com/44
        let contentViewHeight = contentView.frame.height
        let contentViewWidth = contentView.frame.width
        if contentViewHeight < scrollView.frame.size.height {
            scrollView.contentSize = CGSize(width: contentViewWidth, height: scrollView.frame.height + 20)
        } else {
            scrollView.contentSize = CGSize(width: contentViewWidth, height: contentViewHeight)
        }
    }
 
    // MARK: - Attribute
    func attribute() { }
    
    // MARK: - Layout
    func layout() { }
    
    // MARK: - Bind
    func bind() {
        viewBinding()
        viewModelBinding()
        alertBinding()
    }
    
    func viewBinding() { }
    
    func viewModelBinding() {
        viewModel
            .navigationPoptoRootRelay
            .bind(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: bag)
        
        viewModel
            .navigationPopToSelfRelay
            .bind(with: self) { owner, _ in
                owner.navigationController?.popToViewController(owner, animated: true)
            }
            .disposed(by: bag)
        
        viewModel
            .navigationPopViewControllerRelay
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: bag)
        
        viewModel
            .navigationPushViewControllerRelay
            .bind(with: self) { owner, viewController in
                guard let viewController else { return }
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: bag)
        
        viewModel
            .presentViewControllerWithAnimationRelay
            .bind(with: self) { owner, viewController in
                guard let viewController else { return }
                owner.present(viewController, animated: true)
            }
            .disposed(by: bag)
        
        viewModel
            .presentViewControllerNoAnimationRelay
            .bind(with: self) { owner, viewController in
                guard let viewController else { return }
                owner.present(viewController, animated: false)
            }
            .disposed(by: bag)
        
        viewModel
            .dismissSelfNoAnimationRelay
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: false)
            }
            .disposed(by: bag)
        
        viewModel
            .dismissSelfWithAnimationRelay
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: bag)
        
        viewModel.dismissSelfAnimationClosureRelay
            .bind(with: self) { owner, closure in
                owner.dismiss(animated: true, completion: closure)
            }
            .disposed(by: bag)
    }
    
    func alertBinding() {
        viewModel.alertMessageRelay
            .bind(with: self) { owner, message in
                switch message.alertType {
                case .popup:
                    let alertVC = AlertViewController(state: .init(title: message.title,
                                                                   message: message.message,
                                                                   alertType: message.alertType,
                                                                   closeAction: message.closeAction))
                    alertVC.modalPresentationStyle = .overCurrentContext
                    owner.viewModel.presentViewControllerNoAnimationRelay.accept(alertVC)
                case .toast:
                    guard let superView = owner.view.superview else { return }
                    
                    // 이미 떠있는 토스트 제거
                    superView.subviews.forEach {
                        ($0 as? ToastView)?.dismiss()
                    }
                    
                    let toast = ToastView(
                        text: message.title,
                        completionHandler: message.closeAction
                    )
                    superView.addSubview(toast)
                    
                    NSLayoutConstraint.activate([
                        toast.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
                        toast.leadingAnchor.constraint(greaterThanOrEqualTo: superView.leadingAnchor, constant: 15),
                        toast.trailingAnchor.constraint(lessThanOrEqualTo: superView.trailingAnchor, constant: -15),
                        toast.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
                        toast.heightAnchor.constraint(lessThanOrEqualToConstant: 58)
                    ])
                }
            }
            .disposed(by: bag)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
