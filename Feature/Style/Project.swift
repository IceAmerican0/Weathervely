import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "Style",
        targets: [
            Target.build(model: .init(
                name: "Style",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                dependencies: [
                    .SPM.RxDataSources,
                    .SPM.RxGesture,
                    .SPM.KeychainAccess,
                    .Project.Network,
                    .Project.Platform.DesignSystem
                ],
                settings: .settings()
            ))
        ]
    )
)
