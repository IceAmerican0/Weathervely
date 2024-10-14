import ProjectDescription
import DescriptionHelperPlugin

public struct TargetModel {
    let name: String
    let deploymentTargets: DeploymentTargets?
    let bundleId: String
    let infoPlist: InfoPlist
    let sources: SourceFilesList
    let resources: ResourceFileElements?
    let targets: [Target]
    let copyFiles: [CopyFilesAction]?
    let headers: Headers?
    let entitlements: Entitlements?
    let scripts: [TargetScript]
    let dependencies: [TargetDependency]
    let settings: Settings
    let coreDataModels: [CoreDataModel]
    let launchArguments: [LaunchArgument]
    let additionalFiles: [FileElement]
    
    public init(
        name: String,
        bundleId: String = "com.redthree.weathervely",
        deploymentTargets: DeploymentTargets? = .iOS("17.0"),
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        targets: [Target] = [],
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings,
        coreDataModels: [CoreDataModel] = [],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = []
    ) {
        self.name = name
        self.deploymentTargets = deploymentTargets
        self.bundleId = bundleId
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.targets = targets
        self.copyFiles = copyFiles
        self.headers = headers
        self.entitlements = entitlements
        self.scripts = scripts
        self.dependencies = dependencies
        self.settings = settings
        self.coreDataModels = coreDataModels
        self.launchArguments = launchArguments
        self.additionalFiles = additionalFiles
    }
}
