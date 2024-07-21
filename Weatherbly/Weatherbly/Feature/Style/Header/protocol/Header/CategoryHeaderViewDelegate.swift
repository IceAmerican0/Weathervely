//
//  CategoryHeaderViewDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/16/24.
//

import Foundation

protocol CategoryHeaderViewDelegate: AnyObject {
    func sendCategoryWithType(_ view: CategoryHeaderView, tags: [Int], typeInfo: ClosetTypeInfo)
}
