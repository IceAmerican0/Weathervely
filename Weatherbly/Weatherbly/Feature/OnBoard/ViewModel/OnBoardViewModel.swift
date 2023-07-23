//
//  OnBoardViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import UIKit

class OnBoardViewModel: RxBaseViewModel {
    
    func nicknameViewController() -> UIViewController {
        let viewController = NicknameViewController(NicknameViewModel())
        
        return viewController
    }
}
