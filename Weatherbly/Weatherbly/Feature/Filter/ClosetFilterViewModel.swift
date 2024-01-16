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
    
    var styleFilterList: PublishRelay<[String: String]> { get }
    var itemFilterList: PublishRelay<[String: String]> { get }
}

final class ClosetFilterViewModel: RxBaseViewModel, ClosetFilterViewModelLogic {
    var styleFilterList: PublishRelay<[String : String]>
    var itemFilterList: PublishRelay<[String : String]>
    
    override init() {
        self.styleFilterList = .init()
        self.itemFilterList = .init()
        super.init()
    }
    
    /// 초기화
    func didTapReset() {
        
    }
    
    /// 필터 완료
    func didTapConfirm() {
        
    }
}
