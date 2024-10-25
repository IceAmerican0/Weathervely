import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "Network",
        targets: [
            Target.build(model: .init(
                name: "Network",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                resources: ResourceFileElements.baseResources,
                dependencies: [
                    .SPM.RxSwift,
                    .SPM.Moya,
                    .SPM.RxMoya
                ],
                settings: .settings(defaultSettings: Settings.defaultSetting)
            ))
        ]
    )
)
