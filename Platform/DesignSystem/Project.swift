import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "DesignSystem",
        targets: [
            Target.build(model: .init(
                name: "DesignSystem",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                dependencies: [
                    .SPM.RxSwift,
                    .SPM.RxCocoa,
                    .SPM.RxRelay,
                    .SPM.RxGesture,
                    .SPM.Then,
                    .SPM.FlexLayout,
                    .SPM.PinLayout,
                    .Project.Platform.UIUtil
                ],
                settings: .settings()
            ))
        ]
    )
)
