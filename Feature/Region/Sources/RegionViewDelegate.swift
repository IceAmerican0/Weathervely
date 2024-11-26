//
//  RegionViewDelegate.swift
//  Region
//
//  Created by Khai on 11/26/24.
//  Copyright © 2024 Weathervely. All rights reserved.
//

import UIKit

public protocol RegionViewDelegate {
    func backButtonTapped()
    func changeButtonTapped()
    func addButtonTapped()
    func regionEntered(state: SettingRegionState)
}
