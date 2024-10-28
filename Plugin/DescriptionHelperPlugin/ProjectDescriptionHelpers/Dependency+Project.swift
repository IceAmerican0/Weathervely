import ProjectDescription

extension Dep {
    public struct Project {
        public static let Weathervely = weathervelyPath()
        
        public static let Network = networkPath()
        
        public static let Platform: PlatformBP<Dep> = PlatformBP(
            DesignSystem: designPath(),
            UIUtil: uiUtilPath(),
            ResourcePackage: resourcePath(),
            WVAlert: alertPath()
        )
        
        public static let Feature: FeatureBP<Dep> = FeatureBP(
            ClosetDetail: featurePath(name: "ClosetDetail"),
            Forecast: featurePath(name: "Forecast"),
            Home: featurePath(name: "Home"),
            Location: featurePath(name: "Location"),
            Notification: featurePath(name: "Notification"),
            OnBoard: featurePath(name: "OnBoard"),
            Setting: featurePath(name: "Setting"),
            Style: featurePath(name: "Style")
        )
    }
}

public struct PlatformBP<WVType> {
    public let DesignSystem: WVType
    public let UIUtil: WVType
    public let ResourcePackage: WVType
    public let WVAlert: WVType
}

public struct FeatureBP<WVType> {
    public let ClosetDetail: WVType
    public let Forecast: WVType
    public let Home: WVType
    public let Location: WVType
    public let Notification: WVType
    public let OnBoard: WVType
    public let Setting: WVType
    public let Style: WVType
}
