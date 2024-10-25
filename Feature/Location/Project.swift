import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "Location",
        targets: [
            Target.build(model: .init(
                name: "Location",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                resources: ResourceFileElements.baseResources,
                dependencies: [
                    .SPM.RxCocoa,
                    .SPM.RxRelay,
                    .SPM.RxGesture,
                    .SPM.Then,
                    .Project.Network,
                ] + .PlatformDeps,
                settings: .settings(defaultSettings: Settings.defaultSetting)
            ))
        ]
    )
)
