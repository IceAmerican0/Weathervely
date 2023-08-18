//
//  WebViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/18.
//

import Foundation
import WebKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxGesture

public class WebViewController: UIViewController, CodeBaseInitializerProtocol {
    
    let container = UIView()
    var webView: WKWebView!
    
    let urlString: String
    let bag = DisposeBag()
    
    public init(_ urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        codeBaseInitializer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(container)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    func attribute() {
        webView = WKWebView(frame: .zero).then {
            if let url = URL(string: urlString) {
                $0.load(URLRequest(url: url))
            }
            $0.navigationDelegate = self
        }
    }
    
    func layout() {
        container.pin.all(view.pin.safeArea)
        container.flex.layout()
        
        container.flex.define { flex in
            flex.addItem(webView).width(100%).height(100%)
        }
    }
    
    func bind() {
        webView.rx.swipeGesture(.right)
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                if self?.webView.canGoBack == true {
                    self?.webView.goBack() // Go back in web navigation history
                } else {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: bag)
    }
}

extension WebViewController: WKNavigationDelegate {
    
}
