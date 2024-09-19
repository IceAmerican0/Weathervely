//
//  StyleBanner.swift
//  Weatherbly
//
//  Created by 최수훈 on 5/6/24.
//

import UIKit
import RxDataSources

public struct StyleBanner: Equatable, IdentifiableType {
    public let identity = UUID()
    
    let styleBanner = UIImage.style_banner
}
