import ProjectDescription

extension [Dep] {
    public static let FeatureDeps: [Dep] = [
        .Project.Feature.ClosetDetail,
        .Project.Feature.Forecast,
        .Project.Feature.Home,
        .Project.Feature.Location,
        .Project.Feature.Notification,
        .Project.Feature.OnBoard,
        .Project.Feature.Setting,
        .Project.Feature.Style
    ]
    
    public static let FeatureBaseDeps: [Dep] = [
        .Project.Platform.WVAlert,
        .Project.Platform.DesignSystem,
        .Project.Network
    ]
}
