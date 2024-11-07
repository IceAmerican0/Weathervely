import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(model: .init(
    name: "Home",
    targets: [
        Target.build(model: .init(
            name: "Home",
            product: .staticLibrary,
            sources: [.glob(.relativeToCurrentFile("Sources/**"))],
            dependencies: [
                .SPM.RxDataSources,
                .Project.Platform.WVAlert,
                .Project.Platform.DesignSystem,
                .Project.WVNetwork
            ],
            settings: .basicSetting
        ))
    ]
))
