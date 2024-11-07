import Foundation
import ProjectDescription
import DescriptionHelperPlugin

public extension Target {
    static func build(model: TargetModel) -> Target {
        let settings = Settings.settings(
            base: model.product == .framework ?
            model.settings.base.merging(["OTHER_LDFLAGS" : "$(inherited) -all_load"]) : model.settings.base,
            configurations: model.settings.configurations,
            defaultSettings: model.settings.defaultSettings
        )
        
        
        return Target.target(
            name: model.name,
            destinations: [.iPhone],
            product: model.product,
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
            settings: settings,
            coreDataModels: model.coreDataModels,
            launchArguments: model.launchArguments,
            additionalFiles: model.additionalFiles
        )
    }
}
