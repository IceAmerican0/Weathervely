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
    private var exitButton = UIButton().then {
        $0.setImage(.filter_exit, for: .normal)
    }
    
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
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
    }
    
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    ).then {
        $0.delegate = self
        $0.dataSource = self
        let index = viewModel.viewState.rawValue
        $0.setViewControllers(
            [filterViewControllers[index]],
            direction: index == 0 ? .reverse : .forward,
            animated: true
        )
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
    
    private lazy var currentPage = BehaviorRelay<Int>(value: viewModel.viewState.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // FilterListViewDelegate
        filterViewControllers.forEach { vc in
            if let vc = vc as? FilterListViewController {
                vc.delegate = self
            }
        }
        
        // UIScrollViewDelegate
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
        
        currentPage
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
        
        setBottomSheet()
    }

    override func layout() {
        super.layout()
        
        container.flex.define {
            $0.addItem(exitButton).alignSelf(.end).marginTop(16).marginRight(20).size(24)
            $0.addItem().horizontally(20).define { head in
                head.addItem(segmentView).width(view.bounds.width - 40).height(48)
            }
            $0.addItem().backgroundColor(.gray30).width(100%).height(1)
            $0.addItem(pageViewController.view).width(100%).height(350)
            $0.addItem().direction(.row).paddingTop(20).width(100%).height(88).define { bottom in
                bottom.addItem(resetButton).marginLeft(20).width(72).height(48)
                bottom.addItem(confirmButton).marginLeft(8).marginRight(20).height(48).grow(1)
            }
        }
    }
    
    override func viewBinding() {
        super.viewBinding()
        
        exitButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: bag)
        
        resetButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.view.layoutIfNeeded()
            }.disposed(by: bag)
        
        confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: bag)
    }
    
    @objc func changeValue(control: UISegmentedControl) {
        if currentPage.value == control.selectedSegmentIndex { return }
        currentPage.accept(control.selectedSegmentIndex)
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
        return filterViewControllers[next]
    }
}

extension ClosetFilterViewController: UIScrollViewDelegate {
    /// 실시간 스크롤 처리 절반 이상시 페이지 넘어가도록
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.x - view.frame.size.width
        let percent = abs(position) / view.frame.size.width
        
        let nowPage = currentPage.value
        
        DispatchQueue.main.async {
            if percent > 0.5 {
                if position > 0 {
                    self.segmentView.selectedSegmentIndex = nowPage + 1
                } else {
                    if nowPage == 0 { return }
                    self.segmentView.selectedSegmentIndex = nowPage - 1
                }
            } else {
                self.segmentView.selectedSegmentIndex = nowPage
                return
            }
//            self.currentPage.accept(self.segmentView.selectedSegmentIndex)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {
            if self.currentPage.value != self.segmentView.selectedSegmentIndex {
                self.currentPage.accept(self.segmentView.selectedSegmentIndex)
            }
        }
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
