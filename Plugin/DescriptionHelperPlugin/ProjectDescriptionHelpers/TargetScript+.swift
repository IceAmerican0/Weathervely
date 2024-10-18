import ProjectDescription

public extension TargetScript {
    static let Weathervely: [TargetScript] = [
        .FirebaseCrashLytics,
        .BuildNumberRunScript
    ]
}

private extension TargetScript {
    static let FirebaseCrashLytics = ProjectDescription.TargetScript.post(
        script: """
                if [ "${CONFIGURATION}" != "Debug" ]; then
                    if [ -d "$SRCROOT/../.build/checkouts/firebase-ios-sdk/Crashlytics" ]; then
                        "$SRCROOT/../.build/checkouts/firebase-ios-sdk/Crashlytics/run"
                    else
                        echo "Crashlytics has not been installed properly."
                    fi
                else
                    echo "Executing Debug Mode, Crashlytics Disabled"
                fi
                """,
        name: "Firebase Crashlytics",
        inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
            "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
        ]
    )
    
    static let BuildNumberRunScript = ProjectDescription.TargetScript.post(
        script: """
                BUILD_NUMBER_WITH_CURRENT_DATE=$(date "+%Y.%m.%d.%H.%M")

                /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${BUILD_NUMBER_WITH_CURRENT_DATE}" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
                """,
        name: "Run Script - Build Number",
        runForInstallBuildsOnly: true
    )
}
