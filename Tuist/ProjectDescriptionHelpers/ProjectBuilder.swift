import ProjectDescription

public extension Project {
    static func build(model: ProjectModel) -> Project {
        Project(
            name: model.name,
            organizationName: model.organizationName,
            packages: model.packages,
            settings: model.settings,
            targets: model.targets,
            schemes: [],
            additionalFiles: model.additionalFiles,
            resourceSynthesizers: model.resourceSynthesizers
        )
    }
}
