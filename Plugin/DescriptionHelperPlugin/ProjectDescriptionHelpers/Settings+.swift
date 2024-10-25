import ProjectDescription

extension Settings {
    public static let defaultSetting: DefaultSettings = .recommended(excluding: [
        "GCC_PREPROCESSOR_DEFINITIONS"
    ])
    
    public static let baseSetting = Settings.settings(
        base: SettingsDictionary()
            .automaticCodeSigning(devTeam: "$(DEVELOPMENT_TEAM)")
            .merging([
                "PRODUCT_BUNDLE_IDENTIFIER": "$(BUNDLE_ID)",
                "CODE_SIGN_STYLE": "$(CODE_SIGN_STYLE)",
                "CODE_SIGN_IDENTITY": "$(CODE_SIGN_IDENTITY)",
                "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)",
                "PROVISIONING_PROFILE_SPECIFIER": "$(PROVISIONING_PROFILE)",
                "OTHER_LDFLAGS" : "$(inherited) -all_load"
            ])
        ,
        configurations: [
            .debug(
                name: "Debug",
                settings: ["GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1"],
                xcconfig: .relativeToRoot("Weathervely/Configurations/Debug.xcconfig")
            ),
            .release(
                name: "Release",
                xcconfig: .relativeToRoot("Weathervely/Configurations/Release.xcconfig")
            )
        ],
        defaultSettings: defaultSetting
    )
    
    public static let featureSetting = Settings.settings(
        configurations: [
            .debug(
                name: "Debug",
                settings: ["GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1"],
                xcconfig: .relativeToRoot("Weathervely/Configurations/Debug.xcconfig")
            ),
            .release(
                name: "Release",
                xcconfig: .relativeToRoot("Weathervely/Configurations/Release.xcconfig")
            )
        ],
        defaultSettings: defaultSetting
    )
}
