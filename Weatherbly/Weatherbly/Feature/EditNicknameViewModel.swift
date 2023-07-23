//
//  EditNicknameViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/11.
//

import UIKit
import RxSwift
import RxCocoa

class EditNicknameViewModel: RxBaseViewModel {
    
    var bottomButtonDidTapRelay = BehaviorRelay<UITextField.editMode>(value: .justShow)
    
    func bottomButtonDidTap() {
        if bottomButtonDidTapRelay.value == .justShow {
            bottomButtonDidTapRelay.accept(.editing)
        } else {
            bottomButtonDidTapRelay.accept(.justShow)
        }
    }
}
