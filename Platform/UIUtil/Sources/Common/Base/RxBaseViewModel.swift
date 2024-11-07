//
//  RxBaseViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/16.
//

import UIKit
import RxSwift
import RxRelay

public protocol ViewModelBusinessLogic: AnyObject {}

public protocol ViewModelable: AnyObject {}

open class RxBaseViewModel: BaseDisposebag, ViewModelable {
    public let bag = DisposeBag()
    
    public let viewWillAppearRelay = PublishRelay<Void>()
    public let viewDidAppearRelay = PublishRelay<Void>()
    public let viewWillDisAppearRelay = PublishRelay<Void>()
    public let viewDidDisAppearRelay = PublishRelay<Void>()
    
    public let navigationPoptoRootRelay = PublishRelay<Void>()
    public let navigationPopToSelfRelay = PublishRelay<Void>()
    public let navigationPopViewControllerRelay = PublishRelay<Void>()

    public let navigationPushViewControllerRelay = PublishRelay<UIViewController?>()
    public let navigationPushToPreviousViewControllerRelay = PublishRelay<[UIViewController]?>()
    public let navigationSetRootPushViewControllerRelay = PublishRelay<UIViewController?>()
    public let presentViewControllerWithAnimationRelay = PublishRelay<UIViewController?>()
    public let presentViewControllerNoAnimationRelay = PublishRelay<UIViewController?>()
    public let dismissSelfWithAnimationRelay = PublishRelay<Void>()
    public let dismissSelfNoAnimationRelay = PublishRelay<Void>()
    public let dismissSelfAnimationClosureRelay = PublishRelay<(() -> Void)>()
    
    public init() {
        baseBinding()
    }
    
    func baseBinding() {}
    
    func bindInnerViewModelPresentationToSelf(_ innerViewModel: RxBaseViewModel) {
        innerViewModel.navigationPoptoRootRelay
            .bind(to: navigationPoptoRootRelay)
            .disposed(by: bag)
        innerViewModel.navigationPopToSelfRelay
            .bind(to: navigationPopToSelfRelay)
            .disposed(by: bag)
        innerViewModel.navigationPopViewControllerRelay
            .bind(to: navigationPopViewControllerRelay)
            .disposed(by: bag)
        innerViewModel.navigationPushViewControllerRelay
            .bind(to: navigationPushViewControllerRelay)
            .disposed(by: bag)
        innerViewModel.navigationPushToPreviousViewControllerRelay
            .bind(to: navigationPushToPreviousViewControllerRelay)
            .disposed(by: bag)
        innerViewModel.navigationSetRootPushViewControllerRelay
            .bind(to: navigationSetRootPushViewControllerRelay)
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
