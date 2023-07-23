//
//  EditRegionViewController.swift
//  Weatherbly
//
//  Created by 박성준 on 2023/07/12.
//

import UIKit
import PinLayout
import FlexLayout

final class EditRegionViewController: RxBaseViewController<EmptyViewModel> {
    
    private var navigationView = CSNavigationView(.leftButton(AssetsImage.navigationBackButton.image))
    
    private let contentWrapper = UIView()
    private let outlineImage = UIImageView()
    private let subtitleLabel = CSLabel(.bold, 18, "즐겨 찾는 동네 (최대 3개)")
    private var favoriteTableView = UITableView()
    private var confirmButton = CSButton(.primary)
    
    private let textFieldMarginHeight = UIScreen.main.bounds.height * 0.186
    private let buttonMarginBottom = UIScreen.main.bounds.height * 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func attribute() {
        super.attribute()
        
        navigationView.do {
            $0.setTitle("동네 설정")
            $0.addBorder(.bottom)
        }
        
        outlineImage.do {
            $0.setAssetsImage(AssetsImage.rightArrow)
        }
        
        favoriteTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.isScrollEnabled = false
            $0.backgroundColor = CSColor._253_253_253.color
            $0.layer.cornerRadius = 5
            $0.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        }
        
        confirmButton.do {
            $0.setTitle("동네 추가하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    override func layout() {
        super.layout()
        
        container.flex.alignItems(.center).define { flex in
            flex.addItem(navigationView).width(UIScreen.main.bounds.width)
            flex.addItem(contentWrapper).direction(.row).alignItems(.center).marginLeft(21).marginTop(64).define { flex in
                flex.addItem(outlineImage).size(24)
                flex.addItem(subtitleLabel).marginLeft(3).height(28)
            }
            flex.addItem(confirmButton).width(88%).height(62)
            flex.addItem().width(UIScreen.main.bounds.width).height(300).define { flex in
                flex.addItem()
            }
        }
        
        confirmButton.pin.bottom(buttonMarginBottom)
    }
}

// MARK: UITableViewDelegate
extension EditRegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 100 }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 25 }
    
}

extension EditRegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 3 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(withType: DailyForecastTableViewCell.self, for: indexPath).then {
            $0.valueLabel.text = ""
        }
    }
}
