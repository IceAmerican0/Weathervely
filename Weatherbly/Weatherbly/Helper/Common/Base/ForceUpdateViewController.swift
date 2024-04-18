//
//  ForceUpdateViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/09/07.
//

import UIKit

final class ForceUpdateViewController: RxBaseViewController<EmptyViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.backgroundColor = .white
        
        self.viewModel.alertState.accept(.init(title: "새로운 버전이 출시됐어요!\n앱스토어에서 업데이트해주세요",
                                                      alertType: .popup,
                                                      closeAction: {
            guard let appStoreLink = URL(string: Constants.appStoreLink) else { return }
            UIApplication.shared.open(appStoreLink)
        }))
    }
}
