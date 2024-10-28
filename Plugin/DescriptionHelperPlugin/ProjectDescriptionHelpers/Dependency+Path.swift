import ProjectDescription

extension Dep {
    public static func weathervelyPath() -> Dep {
        .project(
            target: "Weathervely",
            path: .relativeToRoot("Weathervely")
        )
    }
    
    public static func networkPath() -> Dep {
        .project(
            target: "Network",
            path: .relativeToRoot("Network")
        )
    }
    
    public static func featurePath(name: String) -> Dep {
        .project(
            target: name,
            path: .relativeToRoot("Feature/\(name)")
        )
    }
    
    public static func designPath() -> Dep {
        .project(
            target: "DesignSystem",
            path: .relativeToRoot("Platform/DesignSystem")
        )
    }
    
    public static func uiUtilPath() -> Dep {
        .project(
            target: "UIUtil",
            path: .relativeToRoot("Platform/UIUtil")
        )
    }
    
    public static func resourcePath() -> Dep {
        .project(
            target: "ResourcePackage",
            path: .relativeToRoot("Platform/ResourcePackage")
        )
    }
    
    public static func alertPath() -> Dep {
        .project(
            target: "WVAlert",
            path: .relativeToRoot("Platform/WVAlert")
        )
    }
}
