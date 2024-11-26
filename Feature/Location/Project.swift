import ProjectDescription
import ProjectDescriptionHelpers
import DescriptionHelperPlugin

let project = Project.build(model: .init(
    name: "Location",
    targets: [
        Target.build(model: .init(
            name: "Location",
            product: .staticLibrary,
            sources: [.glob(.relativeToCurrentFile("Sources/**"))],
            dependencies: [
                .SPM.KakaoMapsSDK,
                .Project.Platform.WVAlert,
                .Project.Platform.DesignSystem,
                .Project.WVNetwork
            ],
            settings: .basicSetting
        ))
    ]
))
