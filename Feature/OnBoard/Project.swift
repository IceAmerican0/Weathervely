import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "OnBoard",
        targets: [
            Target.build(model: .init(
                name: "OnBoard",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                resources: ResourceFileElements.baseResources,
                dependencies: [
                    .SPM.RxCocoa,
                    .SPM.RxRelay,
                    .SPM.RxGesture,
                    .SPM.Then,
                    .SPM.KeychainAccess,
                    .Project.Network,
                ] + .PlatformDeps,
                settings: .settings(defaultSettings: Settings.defaultSetting)
            ))
        ]
    )
)
