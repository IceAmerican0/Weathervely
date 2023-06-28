//
//  SlotMachineViewController.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/06/28.
//

import UIKit
import FlexLayout
import PinLayout

final class SlotMachineViewController: BaseViewController {
    
    var progressBar = CSProgressView(.bar)
    var navigationBackButton = UIButton()
    
    var mainLabel = CSLabel(.bold,
                            labelText: "'어제' (닉네임) 님에게\n적당했던 옷차림을 골라주세요.",
                            labelFontSize: 22)
    var descriptionLabel = CSLabel(.regular,
                                   labelText: "사진을 위아래로 쓸어보세요.\n다른 두께감의 옷차림이 나와요",
                                   labelFontSize: 20)
    
    var clothViewWrapper = UIView()
    
    var minTempWrapper = UIView()
    var minTempLabel = CSLabel(.regular)
    var minTempImageView = UIImageView()
    var minImageSourceLabel = CSLabel(.regular,
                                      labelText: "by 0000",
                                      labelFontSize: 11)
    
    var maxTempWrapper = UIView()
    var maxTempLabel = CSLabel(.regular)
    var maxTempImageView = UIImageView()
    var maxImageSourceLabel = CSLabel(.regular,
                                      labelText: "by 0000",
                                      labelFontSize: 11)
    
    var confirmButton = CSButton(.primary)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func attribute() {
        super.attribute()
        
//        if UIScreen.main.bounds.width < 376 {
//            $0.font = .boldSystemFont(ofSize: 18)
//        }
        
        //        if UIScreen.main.bounds.width < 376 {
        //            $0.font = .boldSystemFont(ofSize: 16)
        //        }
    }
    
    override func layout() {
        super.layout()
    }
    
    override func bind() {
        super.bind()
    }
    
}
