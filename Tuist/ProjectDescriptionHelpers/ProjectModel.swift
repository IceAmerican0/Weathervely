import ProjectDescription
import DescriptionHelperPlugin

public struct ProjectModel {
    let name: String
    let organizationName: String
    let targets: [Target]
    let packages: [Package]
    let settings: Settings
    let schemes: [Scheme]
    let additionalFiles: [FileElement]
    let resourceSynthesizers: [ResourceSynthesizer]
    
    public init(
        name: String,
        organizationName: String = "Weathervely",
        targets: [Target],
        packages: [Package] = [],
        settings: Settings? = nil,
        schemes: [Scheme] = [],
        additionalFiles: [FileElement] = [],
        resourceSynthesizers: [ResourceSynthesizer] = .default
    ) {
        self.name = name
        self.organizationName = organizationName
        self.targets = targets
        self.packages = packages
        self.settings = settings ?? Settings.baseSetting
        self.schemes = schemes
        self.additionalFiles = additionalFiles
        self.resourceSynthesizers = resourceSynthesizers
    }
}
