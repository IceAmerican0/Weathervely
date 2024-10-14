import ProjectDescription
import DescriptionHelperPlugin

let project = Project(
    name: "ClosetDetail",
    targets: [
        .target(
            name: "ClosetDetail",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.redthree.weathervely",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: .relativeToRoot("Weathervely/Resources/Info.plist")),
            sources: [
                .glob(.relativeToRoot("Weathervely/Sources/Feature/ClosetDetail"))
            ],
            resources: [
                .glob(pattern: .relativeToRoot("Weathervely/Configurations/Common.xcconfig")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/Font/**")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/Colors.xcassets")),
                .glob(pattern: .relativeToRoot("Weathervely/Resources/Images.xcassets")),
            ],
            dependencies: [
                .SPM.RxSwift,
                .SPM.RxCocoa,
                .SPM.RxRelay,
                .SPM.RxDataSources,
                .SPM.RxGesture,
                .SPM.Moya,
                .SPM.RxMoya,
                .SPM.Kingfisher,
                .SPM.Then,
                .SPM.KeychainAccess,
                .SPM.FlexLayout,
                .SPM.PinLayout,
                .SPM.FirebaseAnalytics,
                .SPM.FirebaseCrashlytics,
                .SPM.FirebaseMessaging,
                .SPM.FirebaseRemoteConfig,
                .SPM.KakaoMapsSDK
            ],
            settings: Settings.baseSetting
        )
    ]
)
