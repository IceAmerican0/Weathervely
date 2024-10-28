import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "Notification",
        targets: [
            Target.build(model: .init(
                name: "Notification",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                dependencies: .FeatureBaseDeps,
                settings: .settings()
            ))
        ]
    )
)
