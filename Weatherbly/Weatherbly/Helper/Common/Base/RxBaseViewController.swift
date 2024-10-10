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
        
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
                viewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: bag)
        
        viewModel
            .navigationPushToPreviousViewControllerRelay
            .bind(with: self) { owner, viewControllers in
                guard let firstVC = owner.navigationController?.viewControllers.first,
                      let viewControllers else { return }
                
                viewControllers.forEach { $0.hidesBottomBarWhenPushed = true }
                
                // 첫번째(탭바) 네비게이션만 남긴 후 원하는 네비게이션 배열 적용
                let vc: [UIViewController] = [firstVC] + viewControllers
                owner.navigationController?.setViewControllers(vc, animated: true)
            }
            .disposed(by: bag)
        
        viewModel.navigationSetRootPushViewControllerRelay
            .bind(with: self) { owner, viewController in
                guard let viewController else { return }
                owner.navigationController?.setViewControllers([viewController], animated: true)
            }.disposed(by: bag)
        
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
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                guard let superView = windowScene?.windows.first else { return }
                
                switch state.alertType {
                case .popup:
                    // 이미 떠있는 알럿 제거
                    superView.subviews.forEach {
                        ($0 as? AlertView)?.dismiss()
                    }
                    
                    superView.accessibilityViewIsModal = true
                    
                    let alert = AlertView(state: state)
                    superView.addSubview(alert)
                    
                case .toast:
                    // 이미 떠있는 토스트 제거
                    superView.subviews.forEach {
                        ($0 as? ToastView)?.dismiss()
                    }
                    
                    let toast = ToastView(
                        text: state.title,
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
    
    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        navigationController?.viewControllers.count ?? 0 > 1
    }
}
