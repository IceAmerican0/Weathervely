import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "DesignSystem",
        targets: [
            Target.build(model: .init(
                name: "DesignSystem",
                product: .framework,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                dependencies: [
                    .SPM.RxGesture,
                    .Project.Platform.UIUtil
                ],
                settings: .settings()
            ))
        ]
    )
)
