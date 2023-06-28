//
//  BaseViewController.swift
//  Weathervely
//
//  Created by 박성준 on 2023/06/06.
//

import UIKit
import RxSwift
import Then
import FlexLayout
import PinLayout

class BaseViewController: UIViewController, CodeBaseInitializerProtocol{
    
    var container = UIView()
    
    // MARK: - Initialize

    init(container: UIView = UIView()) {
        super.init(nibName: nil, bundle: nil)
        
        /// attribute, layout, bind 를 호출해서 필요한 코드를 작성하면 된다.
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func viewBindind() { }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    /// child component들의 속성을 잡아주기 위해서 flex.layout()을 먼저 호출한다.
        container.pin.all(view.pin.safeArea)
        container.flex.layout()
        
        layout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        view.backgroundColor = .white
        view.addSubview(container)
    }
 
    // MARK: - Attribute
    func attribute() { }
    
    // MARK: - Layout
    func layout() { }
    
    // MARK: - Bind
    func bind() { }

    
}
