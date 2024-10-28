import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "WVAlert",
        targets: [
            Target.build(model: .init(
                name: "WVAlert",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                dependencies: [
                    .Project.Platform.DesignSystem
                ],
                settings: .settings()
            ))
        ]
    )
)
