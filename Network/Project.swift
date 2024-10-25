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
                dependencies: [
                    .SPM.RxMoya,
                    .Project.Platform.UIUtil
                ],
                settings: .settings()
            ))
        ]
    )
)
