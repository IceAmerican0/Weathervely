//
//  ClosetFilterViewModel.swift
//  Weatherbly
//
//  Created by Khai on 1/15/24.
//

import UIKit

protocol ClosetFilterViewModelLogic: ViewModelBusinessLogic {
    func didTapReset()
    func didTapConfirm()
}

final class ClosetFilterViewModel: RxBaseViewModel, ClosetFilterViewModelLogic {
    /// 초기화
    func didTapReset() {
        
    }
    
    /// 코디 필터
    func didTapConfirm() {
        
    }
}
