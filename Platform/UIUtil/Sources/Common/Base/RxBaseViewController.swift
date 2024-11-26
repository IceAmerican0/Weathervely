//
//  RxBaseViewController.swift
//  Weathervely
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import FlexLayout
import PinLayout

open class RxBaseViewController<ViewModel>:
    UIViewController,
    CodeBaseInitializerProtocol,
    BaseDisposebag,
    UIGestureRecognizerDelegate where ViewModel: RxBaseViewModel {
    
    public lazy var bag: DisposeBag = {
        self.viewModel.bag
    }()
    
    public var viewModel: ViewModel
    
    public var container = UIView()
    
    // MARK: - Initialize

    public init(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        codeBaseInitializer()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.pin.all(view.pin.safeArea)
        container.flex.layout()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(container)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    // MARK: - Layout
    open func layout() { }
    
    // MARK: - Bind
    open func bind() {
        viewBinding()
        viewModelBinding()
    }
    
    open func viewBinding() { }
    
    open func viewModelBinding() {
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
    
    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        navigationController?.viewControllers.count ?? 0 > 1
    }
}
