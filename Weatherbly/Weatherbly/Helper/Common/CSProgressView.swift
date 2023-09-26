//
//  CSProgressView.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/19.
//

import UIKit

public final class CSProgressView: UIProgressView {
    
    private var degree: Float
    
    init(_ degree: Float) {
        self.degree = degree
        super.init(frame: .zero)
        setProgressStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgressStyle() {
        self.do {
            $0.progress = degree
            $0.trackTintColor = CSColor._220_220_220.color
            $0.progressTintColor = CSColor._151_151_151.color
        }
    }
}

