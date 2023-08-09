//
//  RxBaseViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import UIKit
import RxSwift
import RxCocoa

public protocol ViewModelBusinessLogic: AnyObject {}

public protocol ViewModelable: AnyObject {}

public class RxBaseViewModel: BaseDisposebag, ViewModelable {
    
    let bag = DisposeBag()
    
    let alertMessageRelay = PublishRelay<AlertViewState>()
    
    let viewWillAppearRelay = PublishRelay<Void>()
    let viewDidAppearRelay = PublishRelay<Void>()
    let viewWillDisAppearRelay = PublishRelay<Void>()
    let viewDidDisAppearRelay = PublishRelay<Void>()
    
    let navigationPopToSelfRelay = PublishRelay<Void>()
    let navigationPopViewControllerRelay = PublishRelay<Void>()
    let navigationPushViewControllerRelay = PublishRelay<UIViewController?>()
    let presentViewControllerWithAnimationRelay = PublishRelay<UIViewController?>()
    let presentViewControllerNoAnimationRelay = PublishRelay<UIViewController?>()
    let dismissSelfWithAnimationRelay = PublishRelay<Void>()
    let dismissSelfNoAnimationRelay = PublishRelay<Void>()
    let dismissSelfAnimationClosureRelay = PublishRelay<(() -> Void)>()
    
    public init() {
        baseBinding()
    }
    
    func baseBinding() {}
    
    func bindInnerViewModelPresentationBindingToSelf(_ innerViewModel: RxBaseViewModel) {
        innerViewModel.navigationPopToSelfRelay
            .bind(to: navigationPopToSelfRelay)
            .disposed(by: bag)
        innerViewModel.navigationPopViewControllerRelay
            .bind(to: navigationPopViewControllerRelay)
            .disposed(by: bag)
        innerViewModel.navigationPushViewControllerRelay
            .bind(to: navigationPushViewControllerRelay)
            .disposed(by: bag)
        innerViewModel.presentViewControllerWithAnimationRelay
            .bind(to: presentViewControllerWithAnimationRelay)
            .disposed(by: bag)
        innerViewModel.presentViewControllerNoAnimationRelay
            .bind(to: presentViewControllerNoAnimationRelay)
            .disposed(by: bag)
        innerViewModel.dismissSelfWithAnimationRelay
            .bind(to: dismissSelfWithAnimationRelay)
            .disposed(by: bag)
        innerViewModel.dismissSelfNoAnimationRelay
            .bind(to: dismissSelfNoAnimationRelay)
            .disposed(by: bag)
        innerViewModel.dismissSelfAnimationClosureRelay
            .bind(to: dismissSelfAnimationClosureRelay)
            .disposed(by: bag)
    }
}
