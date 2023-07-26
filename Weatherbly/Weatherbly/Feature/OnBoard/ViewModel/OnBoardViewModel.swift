//
//  OnBoardViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import UIKit

public protocol OnBoardViewModelLogic: ViewModelBusinessLogic {
    func toNicknameView()
}

public final class OnBoardViewModel: RxBaseViewModel {
    
    public func toNicknameView() {
        let vc = NicknameViewController(NicknameViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
}
