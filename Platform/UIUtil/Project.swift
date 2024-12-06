import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(model: .init(
    name: "UIUtil",
    targets: [
        Target.build(model: .init(
            name: "UIUtil",
            product: .framework,
            sources: [.glob(.relativeToCurrentFile("Sources/**"))],
            dependencies: [
                .SPM.RxSwift,
                .SPM.RxCocoa,
                .SPM.FlexLayout,
                .SPM.PinLayout,
                .SPM.Then,
                .SPM.KeychainAccess
            ],
            settings: .basicSetting
        ))
    ]
))
