import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(model: .init(
    name: "Weathervely",
    targets: [
        Target.build(model: .init(
            name: "Weathervely",
            bundleId: "com.redthree.weathervely",
            infoPlist: .file(path: .relativeToCurrentFile("Resources/Info.plist")),
            sources: [
                .glob(.relativeToCurrentFile("Sources/**"))
            ],
            resources: [
                .glob(pattern: .relativeToRoot("Weathervely/Configurations/Common.xcconfig")),
                .glob(pattern: .relativeToCurrentFile("Resources/Images.xcassets")),
                .glob(pattern: .relativeToCurrentFile("Resources/LaunchScreen.storyboard")),
                .glob(pattern: .relativeToCurrentFile("Resources/GoogleService-Info.plist")),
                .glob(pattern: .relativeToCurrentFile("Resources/PrivacyInfo.xcprivacy"))
            ],
            entitlements: .file(path: .relativeToCurrentFile("Resources/Weathervely.entitlements")),
            scripts: TargetScript.Weathervely,
            dependencies: [
                .SPM.FirebaseAnalytics,
                .SPM.FirebaseCrashlytics,
                .SPM.FirebaseMessaging,
                .SPM.FirebaseRemoteConfig,
                .Project.Platform.WVAlert,
                .Project.WVNetwork
            ] + .FeatureDeps
        ))
    ],
    settings: Settings.baseSetting,
    resourceSynthesizers: [
        .plists()
    ]
))
