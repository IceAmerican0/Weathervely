import ProjectDescription

extension ResourceFileElements {
    public static let baseResources = ResourceFileElements.resources([
        .glob(pattern: .relativeToRoot("Weathervely/Configurations/Common.xcconfig")),
        .glob(pattern: .relativeToRoot("Weathervely/Resources/Images.xcassets")),
        .glob(pattern: .relativeToRoot("Weathervely/Resources/LaunchScreen.storyboard")),
        .glob(pattern: .relativeToRoot("Weathervely/Resources/GoogleService-Info.plist")),
        .glob(pattern: .relativeToRoot("Weathervely/Resources/PrivacyInfo.xcprivacy"))
    ])
}
