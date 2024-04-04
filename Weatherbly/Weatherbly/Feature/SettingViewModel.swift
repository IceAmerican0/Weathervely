//
//  SettingViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/09.
//

import UIKit
import RxRelay
import SafariServices

public protocol SettingViewModelLogic: ViewModelBusinessLogic {
    func toEditNicknameView()
    func toEditRegionView()
    func toBeContinue()
    func didTapCollectionViewCell(at index: Int)
    func didTapTableViewCell(at index: Int)
    func didTapSecretReset()
    
    var profileMenuTitle: BehaviorRelay<[ProfileMenuTitle]> { get }
    var menuTitle: BehaviorRelay<[SettingMenuTitle]> { get }
}

final class SettingViewModel: RxBaseViewModel, SettingViewModelLogic {
    /// 내 정보 설정 리스트
    public var profileMenuTitle = BehaviorRelay<[ProfileMenuTitle]>(
        value: ProfileMenuTitle.allCases.map { $0 }
    )
    /// 앱 설정 리스트
    public var menuTitle = BehaviorRelay<[SettingMenuTitle]>(
        value: SettingMenuTitle.allCases.map { $0 }
    )
    /// Gimmick 탭 횟수
    private var secretResetTapCount = 0
    
    func didTapCollectionViewCell(at index: Int) {
        let data = profileMenuTitle.value
        switch data[index] {
        case .region:
            toEditRegionView()
        case .wishList, .sensoryTemp:
            toBeContinue()
        }
    }
    
    func didTapTableViewCell(at index: Int) {
        let data = menuTitle.value
        switch data[index] {
        case .share, .inquiry, .logout, .openSource:
            toBeContinue()
        case .policy:
            toPrivacyPolicyView()
        case .noti, .versionInfo:
            break
        }
    }
    
    func toEditNicknameView() {
        let vc = EditNicknameViewController(EditNicknameViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel(.edit))
        navigationPushViewControllerRelay.accept(vc)
    }
    
    func toPrivacyPolicyView() {
        let urlString = "https://docs.google.com/document/d/1MnwR04jGms26yha2oSdps06Ju0wMn-hGS1Zs6JtDAf8/edit?usp=sharing"
        if let url = URL(string: urlString) {
            let webView = SFSafariViewController(url: url)
            presentViewControllerNoAnimationRelay.accept(webView)
        }
    }
    
    func toBeContinue() {
        alertState.accept(
            .init(
                title: "준비 중인 기능이에요",
                alertType: .toast
            )
        )
    }
    
    // MARK: Gimmick Logic
    func didTapSecretReset() {
        if secretResetTapCount < 5 {
            secretResetTapCount += 1
            stopTask()
        } else {
            secretResetTapCount = 0
            showHiddenAlert()
        }
    }
    
    /// 누르고 3초동안 동작 없을시 횟수 초기화
    private func stopTask() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.secretResetTapCount = 0
        }
    }
    
    private func showHiddenAlert() {
        let leftButton = AlertButtonState(
            title: "계정 초기화",
            action: getUserID
        )
        
        let alert = AlertViewState(
            title: "테스트 기능",
            alertType: .popup,
            buttonListState: .double(
                left: leftButton,
                right: configureServerState()
            )
        )
        alertState.accept(alert)
    }
    
    /// 계정초기화용 ID 가져오기
    private func getUserID() {
        let dataSource = UserDataSource()
        dataSource.getUserInfo()
            .subscribe(
                with: self,
                onNext: { owner, data in
                    guard let id = data.id else { return }
                    owner.resetAccount(userID: id)
                }
            ).disposed(by: bag)
    }
    
    /// 계정초기화
    private func resetAccount(userID: Int) {
        let dataSource = UserDataSource()
        dataSource.resetUserInfo(userID)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    owner.close()
                },
                onError: { owner, error in
                    owner.alertState.accept(
                        .init(
                            title: error.localizedDescription,
                            alertType: .toast
                        )
                    )
                }
            ).disposed(by: bag)
    }
    
    /// 서버변경버튼
    private func configureServerState() -> AlertButtonState {
        var title: String
        var environment: EnvironmentType
        
        switch AppSetting.shared.environmentType {
        case .develop:
            title = "운영 서버로 변경"
            environment = EnvironmentType.production
        case .production:
            title = "테스트 서버로 변경"
            environment = EnvironmentType.develop
        }
        
        return AlertButtonState(
            title: title,
            action: { [weak self] in
                userDefault.set(
                    environment.rawValue,
                    forKey: UserDefaultKey.appEnvironment.rawValue
                )
                self?.close()
            }
        )
    }
    
    private func close() {
        // 부드러운 종료 위한 suspend
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exit(0)
        }
    }
}
