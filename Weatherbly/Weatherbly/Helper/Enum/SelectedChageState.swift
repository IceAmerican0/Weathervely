//
//  SelectedChageState.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/17/24.
//

import Foundation

public enum SelectedChageState {
    case selected
    case deSelected
    
    init(value: Bool) {
        switch value {
        case true: self = .selected
        case false: self = .deSelected
        }
    }
}
