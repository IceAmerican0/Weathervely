import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(model: .init(
    name: "Notification",
    targets: [
        Target.build(model: .init(
            name: "Notification",
            product: .staticLibrary,
            sources: [.glob(.relativeToCurrentFile("Sources/**"))],
            dependencies: [
                .Project.Platform.WVAlert,
                .Project.Platform.DesignSystem,
                .Project.WVNetwork
            ],
            settings: .basicSetting
        ))
    ]
))
