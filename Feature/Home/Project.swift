import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "Home",
        targets: [
            Target.build(model: .init(
                name: "Home",
                sources: [""],
                targets: [
                ],
                dependencies: [
                ],
                settings: Settings.baseSetting
            ))
        ]
    )
)
