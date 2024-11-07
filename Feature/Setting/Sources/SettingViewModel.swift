//
//  SettingViewModel.swift
//  Weatherbly
//
//  Created by 최수훈 on 2023/07/09.
//

import WVAlert
import UIUtil
import WVNetwork
import UIKit
import RxCocoa
import SafariServices

public protocol SettingViewModelLogic: ViewModelBusinessLogic {
    func toEditNicknameView()
    func didTapCollectionViewCell(at index: Int)
    func didTapTableViewCell(at index: Int)
    func pushSetting(selected: Bool)
    func showHiddenAlert()
    
    var toastRelay: PublishRelay<String> { get }
    var profileMenuTitle: BehaviorRelay<[ProfileMenuTitle]> { get }
    var menuTitle: BehaviorRelay<[SettingMenuTitle]> { get }
}

public final class SettingViewModel: RxBaseViewModel, SettingViewModelLogic {
    private let userDataSource: UserDataSourceProtocol = UserDataSource()
    /// toast
    public var toastRelay: PublishRelay<String> = .init()
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
    
    public func didTapCollectionViewCell(at index: Int) {
        let data = profileMenuTitle.value
        switch data[index] {
        case .region:
            toEditRegionView()
        case .notification:
            toNotificationView()
        }
    }
    
    public func didTapTableViewCell(at index: Int) {
        let data = menuTitle.value
        switch data[index] {
        case .notification:
            break
        case .inquiry:
            sendMail()
        case .policy:
            toPrivacyPolicyView()
        case .versionInfo:
            break
        }
    }
    
    /// 푸시 알림 여부
    public func pushSetting(selected: Bool) {
        userDefault.set(selected, forKey: UserDefaultKey.pushAgreement.rawValue)
        userDataSource.fetchPushAgreement(selected)
            .subscribe(
                with: self,
                onNext: { owner, _ in
                    var message = ""
                    
                    if selected {
                        message = "알림 설정이 완료되었어요"
                    } else {
                        message = "알림 설정이 꺼졌어요 알림 받기를 눌러 웨더블리의 날씨 꿀팁을 받아보세요"
                    }
                    
                    owner.toastRelay.accept(message)
                },
                onError: { owner, error in
                    debugPrint("error fetching push agreement: \(error)")
                }
            ).disposed(by: bag)
    }
    
    /// 닉네임 설정
    public func toEditNicknameView() {
        let vc = NicknameViewController(NicknameViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    /// 동네 설정
    private func toEditRegionView() {
        let vc = EditRegionViewController(EditRegionViewModel(.edit))
        navigationPushViewControllerRelay.accept(vc)
    }
    
    /// 알림 설정
    private func toNotificationView() {
        let vc = NotificationListViewController(NotificationListViewModel())
        navigationPushViewControllerRelay.accept(vc)
    }
    
    /// 문의하기
    private func sendMail() {
        let email = "weathervely@gmail.com"
        guard let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }
    
    /// 약관 및 정책
    private func toPrivacyPolicyView() {
        let urlString = "https://docs.google.com/document/d/1MnwR04jGms26yha2oSdps06Ju0wMn-hGS1Zs6JtDAf8/edit?usp=sharing"
        guard let url = URL(string: urlString) else { return }
        let webView = SFSafariViewController(url: url)
        presentViewControllerNoAnimationRelay.accept(webView)
    }
    
    public func showHiddenAlert() {
        let leftButton = AlertButtonState(
            title: "계정 초기화",
            action: getUserID
        )
        
        let alert = AlertViewState(
            title: "테스트 기능",
            buttonListState: .double(
                left: leftButton,
                right: configureServerState()
            )
        )
        AlertManager.shared.present(state: alert)
    }
    
    /// 계정초기화용 ID 가져오기
    private func getUserID() {
        userDataSource.getUserInfo()
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
        userDataSource.resetUserInfo(userID)
            .subscribe(
                with: self,
                onNext: { _, _ in
                    UIApplication.shared.close()
                },
                onError: { owner, error in
                    owner.toastRelay.accept(error.localizedDescription)
                }
            ).disposed(by: bag)
    }
    
    /// 서버변경버튼
    private func configureServerState() -> AlertButtonState {
        var title: String
        var environment: EnvironmentType
        
        switch AppEnvironment.shared.environmentType {
        case .develop:
            title = "운영 서버로 변경"
            environment = EnvironmentType.production
        case .production:
            title = "테스트 서버로 변경"
            environment = EnvironmentType.develop
        }
        
        return AlertButtonState(
            title: title,
            action: {
                userDefault.set(
                    environment.rawValue,
                    forKey: UserDefaultKey.appEnvironment.rawValue
                )
                userDefault.set(true, forKey: UserDefaultKey.isServerChanged.rawValue)
                UIApplication.shared.close()
            }
        )
    }
}
