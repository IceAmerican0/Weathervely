import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "UIUtil",
        targets: [
            Target.build(model: .init(
                name: "UIUtil",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                resources: ResourceFileElements.baseResources,
                dependencies: [
                    .SPM.Kingfisher,
                    .SPM.FlexLayout,
                    .SPM.PinLayout,
                ],
                settings: .settings(defaultSettings: Settings.defaultSetting)
            ))
        ]
    )
)
