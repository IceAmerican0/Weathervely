//
//  CSString.swift
//  Weatherbly
//
//  Created by 최수훈 on 6/25/24.
//

import Foundation
import UIKit

enum CSString: String {
    
    // MARK: - DetailView
    case detailTitle
    case warmDiffTitle = "더 따뜻한 코디"
    case warmDiffDescription = "현재 코디에서 더 따뜻한 코디를 추천드려요"
    case coolDiffTitle = "더 시원한 코디"
    case coolDiffDescription = "현재 코디에서 더 시원한 코디를 추천드려요"
    
    public var string: String {
        return self.rawValue
    }
}
