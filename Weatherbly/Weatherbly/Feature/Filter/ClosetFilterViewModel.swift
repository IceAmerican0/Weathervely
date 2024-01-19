//
//  ClosetFilterViewModel.swift
//  Weatherbly
//
//  Created by Khai on 1/15/24.
//

import UIKit
import RxCocoa

protocol ClosetFilterViewModelLogic: ViewModelBusinessLogic {
    func didTapReset()
    func didTapConfirm()
    
    var viewState: FilterListViewState { get }
}

final class ClosetFilterViewModel: RxBaseViewModel, ClosetFilterViewModelLogic {
    /// 스타일 or 아이템
    var viewState: FilterListViewState
    
    init(viewState: FilterListViewState) {
        self.viewState = viewState
        super.init()
    }
    
    /// 초기화
    func didTapReset() {
        
    }
    
    /// 필터 완료
    func didTapConfirm() {
        
    }
}
