import Foundation
import ProjectDescription
import DescriptionHelperPlugin

public extension Target {
    static func build(model: TargetModel) -> Target {
        Target.target(
            name: model.name,
            destinations: [.iPhone],
            product: .app,
            bundleId: model.bundleId,
            deploymentTargets: model.deploymentTargets,
            infoPlist: model.infoPlist,
            sources: model.sources,
            resources: model.resources,
            copyFiles: model.copyFiles,
            headers: model.headers,
            entitlements: model.entitlements,
            scripts: model.scripts,
            dependencies: model.dependencies,
            settings: Settings.baseSetting,
            coreDataModels: model.coreDataModels,
            launchArguments: model.launchArguments,
            additionalFiles: model.additionalFiles
        )
    }
}
