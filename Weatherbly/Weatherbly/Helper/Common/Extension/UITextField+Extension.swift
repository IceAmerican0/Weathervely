//
//  UITextField+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/11.
//

import UIKit
import FlexLayout

extension UITextField {
    
    enum editMode {
        case justShow
        case editing
    }
    
    func setEditMode(_ editMode: editMode) {
        if editMode == .justShow {
            self.isEnabled = false
        } else {
            self.isEnabled = true
        }
    }
    
}
