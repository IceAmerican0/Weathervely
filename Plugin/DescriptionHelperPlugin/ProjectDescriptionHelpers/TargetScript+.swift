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
    
    static let DsymRunScript = ProjectDescription.TargetScript.post(
        script: """
                EXEC_PATH="$SRCROOT/../.build/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols"
                PLIST_PATH="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"

                # if [ "${CONFIGURATION}" != "Debug" ]; then
                    if [ -f "$EXEC_PATH" ] && [ -f "$PLIST_PATH" ]; then
                        echo "Submit Debug Symbol to Firebase Crashlytics"
                        "$EXEC_PATH" -gsp "$PLIST_PATH" -p ios "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"
                    else
                        echo "Fail to Submit Debug Symbol. Please check upload-symbols.exec or GoogleService-Info.plist files path."
                    fi
                # else
                #     echo "Executing Debug Mode, Uploading Debug Symbol Disabled"
                # fi

                """,
        name: "Dsym Run Script"
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
