//
//  ForceUpdateViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/09/07.
//

import UIKit

final class ForceUpdateViewController: RxBaseViewController<EmptyViewModel> {
    public var isForceUpdate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.backgroundColor = .white
        
        var alert: AlertViewState
        
//        if isForceUpdate {
            alert = .init(
                title: "새로운 버전이 출시됐어요!\n앱스토어에서 업데이트해주세요",
                alertType: .popup,
                closeAction: {
                    guard let appStoreLink = URL(string: Constants.appStoreLink) else { return }
                    UIApplication.shared.open(appStoreLink)
                }
            )
//        } else {
//            let left: AlertButtonState = .init(
//                title: "나중에",
//                action: { [weak self] in
//                    let vc = HomeTabBarController()
//                    self?.viewModel.navigationSetRootPushViewControllerRelay.accept(vc)
//                }
//            )
//            let right: AlertButtonState = .init(
//                title: "업데이트",
//                action: {
//                    guard let appStoreLink = URL(string: Constants.appStoreLink) else { return }
//                    UIApplication.shared.open(appStoreLink)
//                    
//                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        exit(0)
//                    }
//                }
//            )
//            alert = .init(
//                title: "새로운 버전이 출시됐어요!\n앱스토어에서 업데이트해주세요",
//                alertType: .popup,
//                buttonListState: .double(
//                    left: left,
//                    right: right
//                )
//            )
//        }
        
        self.viewModel.alertState.accept(alert)
    }
}
