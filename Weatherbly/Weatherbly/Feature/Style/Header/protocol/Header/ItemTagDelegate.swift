//
//  ItemTagTapDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/15/24.
//

import UIKit

protocol ItemTagDelegate: AnyObject {
    func itemTagDidTap(categoryInfo: MCategoryInfo?)
}
