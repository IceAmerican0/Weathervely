//
//  AssetsImage.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/

import UIKit

enum AssetsImage: String {
    
    case navigationBackButton
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
