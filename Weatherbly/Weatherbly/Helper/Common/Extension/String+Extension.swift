//
//  String+Extension.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/08/10.
//

import Foundation

extension String {
    
    var addColon: String {
        return String(self.prefix(2)) + ":" + String(self.suffix(2))
    }
}
