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
                    .SPM.RxCocoa,
                    .SPM.RxRelay,
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
