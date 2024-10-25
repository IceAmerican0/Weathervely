import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project(
    name: "Weathervely",
    targets: [
        Target.build(model: .init(
            name: "Weathervely",
            sources: [
                .glob(.relativeToCurrentFile("Sources/**"))
            ],
            resources: ResourceFileElements.baseResources,
            entitlements: .file(path: .relativeToCurrentFile("Resources/Weathervely.entitlements")),
            scripts: TargetScript.Weathervely,
            dependencies: [
                .SPM.FirebaseAnalytics,
                .SPM.FirebaseCrashlytics,
                .SPM.FirebaseMessaging,
                .SPM.FirebaseRemoteConfig,
                .SPM.KakaoMapsSDK,
                .Project.Network,
                .Project.Platform.DesignSystem
            ] + .FeatureDeps
        ))
    ],
    resourceSynthesizers: [ 
        .plists()
    ]
)
