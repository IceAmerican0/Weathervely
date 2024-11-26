import ProjectDescription

let config = Config(
    compatibleXcodeVersions: .all,
    plugins: [
        .local(path: .relativeToRoot("Plugin/DescriptionHelperPlugin"))
    ],
    generationOptions: .options()
)
