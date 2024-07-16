//
//  TagsViewDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/14/24.
//

import Foundation
import UIKit

// protocol so we can tell the controller about selections
protocol CategoryTagsViewDelegate: AnyObject {
    func selectItemTags(_ view: CategoryTagsView?, with tags: [Int])
}
