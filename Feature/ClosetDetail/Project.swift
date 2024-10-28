import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "ClosetDetail",
        targets: [
            Target.build(model: .init(
                name: "ClosetDetail",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                dependencies: [
                    .SPM.RxDataSources,
                    .Project.Platform.WVAlert,
                    .Project.Platform.DesignSystem,
                    .Project.Network
                ],
                settings: .settings()
            ))
        ]
    )
)
