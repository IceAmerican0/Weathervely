// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "RxCocoa": .framework,
        ],
        baseSettings: .settings(configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]),
        targetSettings: [
            "FlexLayout": ["GCC_PREPROCESSOR_DEFINITIONS": "FLEXLAYOUT_SWIFT_PACKAGE=1"]
        ]
    )
#endif

let package = Package(
    name: "WVPackage",
    dependencies: [
        .package(url: "https://github.com/layoutBox/FlexLayout", exact: "1.3.33"),
        .package(url: "https://github.com/layoutBox/PinLayout", .upToNextMajor(from: "1.10.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.7.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/devxoul/Then", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Moya/Moya", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.10.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "11.0.0")),
        .package(url: "https://github.com/kakao-mapsSDK/KakaoMapsSDK-SPM.git", .upToNextMajor(from: "2.12.0")),
    ]
)
