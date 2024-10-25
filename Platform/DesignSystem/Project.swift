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
                resources: ResourceFileElements.baseResources,
                dependencies: [
                    .SPM.RxSwift,
                    .SPM.RxCocoa,
                    .SPM.RxRelay,
                    .SPM.RxDataSources,
                    .SPM.RxGesture,
                    .SPM.Kingfisher,
                    .SPM.Then,
                    .SPM.KeychainAccess,
                    .SPM.FlexLayout,
                    .SPM.PinLayout,
                    .Project.Platform.ResourcePackage
                ],
                settings: .settings(defaultSettings: Settings.defaultSetting)
            ))
        ]
    )
)
