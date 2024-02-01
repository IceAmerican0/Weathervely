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
import RxSwift

final class ClosetFilterViewController: RxBaseViewController<ClosetFilterViewModel> {
    private lazy var segmentView = UnderlineTitleSegmentView(items: ["스타일", "아이템"]).then {
        $0.setTitleTextAttributes(
            [
                .font: UIFont.title_2_SB,
                NSAttributedString.Key.foregroundColor: UIColor.gray80
            ],
            for: .normal
        )
        $0.setTitleTextAttributes(
            [
                .font: UIFont.title_2_B,
                NSAttributedString.Key.foregroundColor: UIColor.gray600
            ],
            for: .selected
        )
        $0.selectedSegmentIndex = viewModel.viewState.rawValue
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    ).then {
        $0.dataSource = self
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        $0.view.backgroundColor = .clear
    }
    
    private var filterViewControllers: [UIViewController] = [
        FilterListViewController(FilterListViewModel(viewState: .style)),
        FilterListViewController(FilterListViewModel(viewState: .item))
    ]
    
    private let buttonView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private var resetButton = NewCSButton(.standard, style: .violet600).then {
        $0.setImage(.filter_reset_dis, for: .normal)
        $0.backgroundColor = .gray30
        $0.isUserInteractionEnabled = false
    }
    
    private let confirmButton = NewCSButton(.standard, style: .violet600).then {
        $0.titleLabel?.font = .title_3_B
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        filterViewControllers.forEach { vc in
            if let vc = vc as? FilterListViewController {
                vc.delegate = self
            }
        }
        
        segmentView.rx.selectedSegmentIndex
            .asDriver()
            .drive(
                with: self,
                onNext: { owner, index in
                    owner.pageViewController.setViewControllers(
                        [owner.filterViewControllers[index]],
                        direction: index == 0 ? .reverse : .forward,
                        animated: true
                    )
                }
            ).disposed(by: bag)
    }

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(segmentView).horizontally(20).width(100%).height(48)
            $0.addItem(pageViewController.view).width(100%).height(350)
            $0.addItem().alignSelf(.end).direction(.row).paddingTop(20).width(100%).height(88).define {
                $0.addItem(resetButton).marginLeft(20).width(72).height(48)
                $0.addItem(confirmButton).marginLeft(8).marginRight(20).height(48).grow(1)
            }
        }
    }
}

// MARK: UIPageViewController Delegate & DataSource
extension ClosetFilterViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = filterViewControllers.firstIndex(of: viewController) else { return nil }
        
        let previous = index - 1
        if previous < 0 {
            return nil
        }
        
        segmentView.selectedSegmentIndex = previous
        
        return filterViewControllers[previous]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = filterViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let next = index + 1
        guard filterViewControllers.count > next else {
            return nil
        }
        
        segmentView.selectedSegmentIndex = next
        
        return filterViewControllers[next]
    }
}

// MARK: FilterListViewDelegate
extension ClosetFilterViewController: FilterListViewDelegate {
    func didTapCell(count: Int, isFiltered: Bool) {
        confirmButton.setTitle("\(count)개 코디 보기", for: .normal)
        
        if isFiltered {
            resetButton.setImage(.filter_reset, for: .normal)
            resetButton.isUserInteractionEnabled = true
        } else {
            resetButton.setImage(.filter_reset_dis, for: .normal)
            resetButton.isUserInteractionEnabled = false
        }
    }
    
    func didTapConfirm() {
        viewModel.navigationPopViewControllerRelay.accept(Void())
    }
}
