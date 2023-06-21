//
//  CSProgressView.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/19.
//

import UIKit

class CSProgressView: UIProgressView, CodeBaseInitializerProtocol {
    
    // MARK: - Control Property
    enum ProgressStyle {
        case bar
        case custom
    }
    
    private var progressStyle: ProgressStyle
    
    // MARK: - Initializer
    init(_ progressStyle: ProgressStyle) {
        self.progressStyle = progressStyle
        super.init(frame: .zero)
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        setProgressStyle()
    }
    
    func setProgressStyle() {
        switch progressStyle {
            case .bar:
                self.do {
                    $0.trackTintColor = CSColor._220_220_220.color
                    $0.progressTintColor = CSColor._151_151_151.color
                }
            case .custom:
                self.do {
                    $0.trackTintColor = CSColor._220_220_220.color
                    $0.progressTintColor = CSColor._151_151_151.color
                }
        }
    }
}

