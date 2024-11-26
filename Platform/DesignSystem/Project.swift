import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(model: .init(
    name: "DesignSystem",
    targets: [
        Target.build(model: .init(
            name: "DesignSystem",
            product: .staticLibrary,
            sources: [.glob(.relativeToCurrentFile("Sources/**"))],
            dependencies: [
                .SPM.RxGesture,
                .SPM.Kingfisher,
                .Project.Platform.UIUtil,
                .Project.Platform.ResourcePackage
            ],
            settings: .basicSetting
        ))
    ]
))
