import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(model: .init(
    name: "WVNetwork",
    targets: [
        Target.build(model: .init(
            name: "WVNetwork",
            product: .staticLibrary,
            sources: [.glob(.relativeToCurrentFile("Sources/**"))],
            dependencies: [
                .SPM.RxMoya,
                .Project.Platform.UIUtil
            ],
            settings: .basicSetting
        ))
    ]
))
