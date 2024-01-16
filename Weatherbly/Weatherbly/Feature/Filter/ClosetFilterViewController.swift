//
//  ClosetFilterViewController.swift
//  Weatherbly
//
//  Created by Khai on 1/15/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxCocoa

final class ClosetFilterViewController: RxBaseViewController<ClosetFilterViewModel> {
    private let segmentView = UnderlineTitleSegmentView(items: ["스타일", "아이템"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    ).then {
        $0.delegate = self
        $0.dataSource = self
        $0.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var filterViewControllers = [
        FilterListViewController(FilterListViewModel(viewState: .style)),
        FilterListViewController(FilterListViewModel(viewState: .item))
    ]
    
    private var subContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let resetButton = NewCSButton(.standard, style: .violet600).then {
        $0.imageView?.image = .filter_reset_dis
        $0.backgroundColor = .gray30
    }
    
    private let confirmButton = NewCSButton(.standard, style: .violet600)

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(segmentView).horizontally(20).marginTop(4).height(48).grow(1)
            $0.addItem(subContainer).grow(1)
            $0.addItem().direction(.row).width(100%).define {
                $0.addItem(resetButton).marginLeft(20).width(72).height(48)
                $0.addItem(confirmButton).marginRight(20).height(48).grow(1)
            }
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        
    }
}

// MARK: UIPageViewController Delegate & DataSource
extension ClosetFilterViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}

extension ClosetFilterViewController: FilterListViewDelegate {
    func didTapCell(selected: [String : String]) {
        
    }
}
