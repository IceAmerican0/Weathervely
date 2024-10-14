import ProjectDescription

public extension TargetScript {
    static let Weathervely: [TargetScript] = [
        .FirebaseCrashLytics,
        .BuildNumberRunScript
    ]
}

private extension TargetScript {
    static let FirebaseCrashLytics = ProjectDescription.TargetScript.pre(
        script: """
                if [ "${CONFIGURATION}" != "Debug" ]; then
                    "${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run"
                fi
                """,
        name: "Firebase Crashlytics"
    )
    
    static let BuildNumberRunScript = ProjectDescription.TargetScript.pre(
        script: """
                BUILD_NUMBER_WITH_CURRENT_DATE=$(date "+%Y.%m.%d.%H.%M")

                /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${BUILD_NUMBER_WITH_CURRENT_DATE}" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
                """,
        name: "Run Script - Build Number",
        runForInstallBuildsOnly: true
    )
}
