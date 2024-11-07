import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(model: .init(
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
                .Project.Platform.WVAlert,
                .Project.WVNetwork
            ] + .FeatureDeps
        ))
    ],
    resourceSynthesizers: [
        .plists()
    ]
))
