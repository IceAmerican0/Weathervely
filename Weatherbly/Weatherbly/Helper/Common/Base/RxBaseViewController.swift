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
        print(#function , "RxVC INit")
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
        
        self.navigationController?.isNavigationBarHidden = true

        view.backgroundColor = .white
        view.addSubview(container)
    }
 
    // MARK: - Attribute
    func attribute() { 
        print(#function ,"RxBaseViewCon")
    }
    
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
                case .Error:
                    let alertVC = AlertViewController(state: .init(title: message.title,
                                                                   message: message.message,
                                                                   alertType: message.alertType,
                                                                   closeAction: message.closeAction))
                    alertVC.modalPresentationStyle = .overCurrentContext
                    owner.viewModel.presentViewControllerNoAnimationRelay.accept(alertVC)
                case .Info:
                    owner.view.showToast(message: message.title, font: .systemFont(ofSize: 16))
                }
            }
            .disposed(by: bag)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
