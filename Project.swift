import ProjectDescription

let project = Project(
    name: "Weatherbly",
    targets: [
        .target(
            name: "Weatherbly",
            destinations: .iOS,
            product: .app,
            bundleId: "com.redthree.weathervely",
            infoPlist: .extendingDefault(
                with: [
                    "UILaundchScreen": "LaunchScreen.storyboard"
                ]
            ),
            sources: [
                .glob(.relativeToRoot("Weatherbly/**"))
            ],
            resources: [
                .glob(pattern: .relativeToCurrentFile("Weatherbly/Weatherbly/Configurations/Common.xcconfig")),
                .glob(pattern: .relativeToCurrentFile("Weatherbly/Weatherbly/Resources/Info.plist")),
                .glob(pattern: .relativeToCurrentFile("Weatherbly/Weatherbly/Resources/GoogleService-Info.plist")),
                .glob(pattern: .relativeToCurrentFile("Weatherbly/Weatherbly/Resources/PrivacyInfo.xcprivacy"))
            ],
            scripts: [
                .pre(
                    script: """
                            if [ "${CONFIGURATION}" != "Debug" ]; then
                                "${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
                            fi
                            """,
                    name: "Firebase Crashlytics"
                ),
                .pre(
                    script: """
                            BUILD_NUMBER_WITH_CURRENT_DATE=$(date "+%Y.%m.%d.%H.%M")

                            /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${BUILD_NUMBER_WITH_CURRENT_DATE}" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
                            """,
                    name: "Run Script - Build Number",
                    runForInstallBuildsOnly: true
                )
            ],
            dependencies: [
            ],
            settings: Settings.settings(
                base: SettingsDictionary()
                    .automaticCodeSigning(devTeam: "$(DEVELOPMENT_TEAM)")
                    .merging([
                        "PRODUCT_BUNDLE_IDENTIFIER": "$(BUNDLE_ID)",
                        "CODE_SIGN_STYLE": "$(CODE_SIGN_STYLE)",
                        "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)",
                        "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)",
                        "PROVISIONING_PROFILE_SPECIFIER": "$(PROVISIONING_PROFILE)"
                    ])
                ,
                configurations: [
                    .debug(name: "Debug", xcconfig: .relativeToRoot("Weatherbly/Weatherbly/Configurations/Debug.xcconfig")),
                    .release(name: "Release", xcconfig: .relativeToRoot("Weatherbly/Weatherbly/Configurations/Release.xcconfig"))
                ],
                defaultSettings: .recommended(excluding: [
                    "GCC_PREPROCESSOR_DEFINITIONS"
                ])
            )
        )
    ],
    resourceSynthesizers: [
        .plists()
    ]
)

//let project = Workspace(
//    name: "Workspace",
//    projects: [
//        "Weatherbly",
//        "DesignSystem/**",
//        "Network/**",
//        "Helper/**",
//        "Feature/**"
//    ]
//)

public typealias Dep = TargetDependency

extension Dep {
    public struct SPM {}
}

public extension Dep.SPM {
    // Base
    static let RxSwift              = Dep.external(name: "RxSwift")
    static let RxCocoa              = Dep.external(name: "RxCocoa")
    static let RxRelay              = Dep.external(name: "RxRelay")
    static let RxDataSources        = Dep.external(name: "RxDataSources")
    static let RxGesture            = Dep.external(name: "RxGesture")
    
    // Network
    static let Moya                 = Dep.external(name: "Moya")
    static let RxMoya               = Dep.external(name: "RxMoya")
    static let Kingfisher           = Dep.external(name: "Kingfisher")
    
    // Utility
    static let Then                 = Dep.external(name: "Then")
    
    // Data
    static let KeychainAccess       = Dep.external(name: "KeychainAccess")
    
    // UI
    static let FlexLayout           = Dep.external(name: "FlexLayout")
    static let PinLayout            = Dep.external(name: "PinLayout")

    // ETC
    static let Firebase  = Dep.external(name: "Firebase")
    static let KakaoMapsSDK        = Dep.external(name: "KakaoMapsSDK-SPM")
}
