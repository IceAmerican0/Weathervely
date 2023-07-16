//
//  OnBoardViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import UIKit

class OnBoardViewModel: RxBaseViewModel {
    
    func nicknameViewController() -> UIViewController {
        
        let viewModel = EditNicknameViewModel()
        let viewController = EditNicknameViewController(viewModel)
        
        return viewController
    }
}
