//
//  PrivatePolicyViewModel.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/08/18.
//

import Foundation
import WebKit

public protocol PrivatePolicyViewModelLogic: ViewModelBusinessLogic {
    func toPrivatePolicyWebView()
}

public final class PrivatePolicyViewModel: RxBaseViewModel, PrivatePolicyViewModelLogic {
    public func toPrivatePolicyWebView() {
        let url = "https://docs.google.com/document/d/1MnwR04jGms26yha2oSdps06Ju0wMn-hGS1Zs6JtDAf8/edit?usp=sharing"
        let webView = WebViewController(url)
        webView.modalPresentationStyle = .overCurrentContext
        presentViewControllerNoAnimationRelay.accept(webView)
    }
}
