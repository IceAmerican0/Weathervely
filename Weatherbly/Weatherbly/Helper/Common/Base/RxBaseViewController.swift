//
//  RxBaseViewController.swift
//  Weathervely
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import RxSwift
import Then
import FlexLayout
import PinLayout

public class RxBaseViewController<ViewModel>:
    UIViewController,
    CodeBaseInitializerProtocol,
    BaseDisposebag,
    UIGestureRecognizerDelegate where ViewModel: RxBaseViewModel {
    
    lazy var bag: DisposeBag = {
        self.viewModel.bag
    }()
    
    var viewModel: ViewModel
    
    var container = UIView()
    
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
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    /// child component들의 속성을 잡아주기 위해서 flex.layout()을 먼저 호출한다.
        container.pin.all(view.pin.safeArea)
        container.flex.layout()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(container)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
    
    func viewBinding() {}
    
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
                viewController.hidesBottomBarWhenPushed = true
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
        viewModel.alertState
            .bind(with: self) { owner, state in
                guard let superView = owner.view.superview else { return }
                
                switch state.alertType {
                case .popup:
                    // 이미 떠있는 알럿 제거
                    superView.subviews.forEach {
                        ($0 as? AlertView)?.dismiss()
                    }
                    
                    superView.accessibilityViewIsModal = true
                    
                    let alert = AlertView(state: state)
                    superView.addSubview(alert)
//                    
//                    NSLayoutConstraint.activate([
//                        alert.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0),
//                        alert.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0),
//                        alert.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0),
//                        alert.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0)
//                    ])
                case .toast:
                    // 이미 떠있는 토스트 제거
                    superView.subviews.forEach {
                        ($0 as? ToastView)?.dismiss()
                    }
                    
                    let toast = ToastView(
                        text: state.title ?? "",
                        completionHandler: state.closeAction
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
            }.disposed(by: bag)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        navigationController?.viewControllers.count ?? 0 > 1
    }
}
