//
//  BaseViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import RxSwift
import Then
import FlexLayout
import PinLayout

class BaseViewController: UIViewController {
    
    var container = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    func configureUI() {
        view.addSubview(container)
        
        container.pin.all()
        container.flex.layout()
    }
    
}
