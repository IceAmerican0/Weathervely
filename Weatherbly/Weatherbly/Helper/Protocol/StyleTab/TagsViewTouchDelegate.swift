//
//  TagsViewDelegate.swift
//  Weatherbly
//
//  Created by 최수훈 on 7/14/24.
//

import Foundation
import UIKit

// protocol so we can tell the controller about selections
public protocol TagsViewTouchDelegate: AnyObject {
    func itemTagView(_ itemTagView: UIView, didSelectItemAt index: Int)
    func itemTagView(_ itemTagView: UIView, didDeSelectItemAt index: Int)
}
