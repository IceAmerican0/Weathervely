import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(
    model: .init(
        name: "UIUtil",
        targets: [
            Target.build(model: .init(
                name: "UIUtil",
                product: .staticLibrary,
                sources: [.glob(.relativeToCurrentFile("Sources/**"))],
                dependencies: [
                    .SPM.RxSwift,
                    .SPM.RxCocoa,
                    .SPM.RxRelay,
                    .SPM.Kingfisher,
                    .SPM.FlexLayout,
                    .SPM.PinLayout,
                    .SPM.Then,
                    .SPM.KeychainAccess,
                    .Project.Platform.ResourcePackage
                ],
                settings: .settings()
            ))
        ]
    )
)
