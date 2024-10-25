import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "ResourcePackage",
        targets: [
            Target.build(model: .init(
                name: "ResourcePackage",
                product: .framework,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                resources: [
                    .glob(pattern: .relativeToCurrentFile("Resources/**"))
                ],
                dependencies: [],
                settings: .settings()
            ))
        ],
        resourceSynthesizers: [
            .assets(),
            .fonts()
        ]
    )
)
