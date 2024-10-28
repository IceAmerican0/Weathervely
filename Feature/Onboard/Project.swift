import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "OnBoard",
        targets: [
            Target.build(model: .init(
                name: "OnBoard",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                dependencies: .FeatureBaseDeps,
                settings: .settings()
            ))
        ]
    )
)
