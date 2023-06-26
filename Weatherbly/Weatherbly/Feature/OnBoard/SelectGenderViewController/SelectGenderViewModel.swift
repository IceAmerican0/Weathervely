//
//  SelectGenderViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/22.
//

import Foundation
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class SelectGenderViewModel {
    
    var genderButtonTap = PublishRelay<UIColor>()
    
    func tapWomanButton() {
        print(#function)
        
        genderButtonTap.accept(genderButtonTap.values )
        print(genderButtonTap.values)
        
        
    }
}
