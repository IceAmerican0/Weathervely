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

public class RxBaseViewController<ViewModel>: UIViewController, CodeBaseInitializerProtocol, BaseDisposebag where ViewModel: RxBaseViewModel {
    
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
        
        layout()
        attribute()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        view.backgroundColor = .white
        view.addSubview(container)
    }
 
    // MARK: - Attribute
    func attribute() { }
    
    // MARK: - Layout
    func layout() { }
    
    // MARK: - Bind
    func bind() {
        viewBinding()
        viewModelBinding()
    }
    
    func viewBinding() {}
    
    func viewModelBinding() {
        viewModel
            .navigationPopToSelfRelay
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToViewController(self, animated: true)
            })
            .disposed(by: bag)
        
        viewModel
            .navigationPopViewControllerRelay
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        .disposed(by: bag)
        
        viewModel
            .navigationPushViewControllerRelay
            .subscribe(onNext: { [weak self] viewController in
                guard let self = self, let viewController = viewController else { return }
                self.navigationController?.pushViewController(viewController, animated: true)
            })
        .disposed(by: bag)
        
        viewModel
            .presentViewControllerWithAnimationRelay
            .subscribe(onNext: { [weak self] viewController in
                guard let self = self, let viewController = viewController else { return }
                self.present(viewController, animated: true)
            })
            .disposed(by: bag)
        
        viewModel
            .presentViewControllerNoAnimationRelay
            .subscribe(onNext: { [weak self] viewController in
                guard let self = self, let viewController = viewController else { return }
                self.present(viewController, animated: false)
            })
            .disposed(by: bag)
        
        viewModel
            .dismissSelfNoAnimationRelay
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: false)
            })
        .disposed(by: bag)
        
        viewModel
            .dismissSelfWithAnimationRelay
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
        .disposed(by: bag)
        
        viewModel.dismissSelfAnimationClosureRelay
            .bind { [weak self] closure in
                self?.dismiss(animated: true, completion: closure)
            }
            .disposed(by: bag)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
