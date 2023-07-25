//
//  HomeViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/13.
//

import Foundation
import RxSwift

public protocol HomeViewModelLogic: ViewModelBusinessLogic {
    
}

public final class HomeViewModel: RxBaseViewModel, HomeViewModelLogic {
    
}
