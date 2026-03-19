// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "TuneBox",
    platforms: [.iOS("16.0")],
    products: [
        .iOSApplication(
            name: "TuneBox",
            targets: ["TuneBox"],
            bundleIdentifier: "com.tunebox.TuneBox",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            iconAssetName: "AppIcon",
            accentColorAssetName: "AccentColor",
            supportedInterfaceOrientations: [.portrait],
            capabilities: [
                .backgroundAudio()
            ],
            additionalInfoPlistContentFilePath: "Resources/AdditionalInfo.plist"
        )
    ],
    targets: [
        .executableTarget(
            name: "TuneBox",
            path: "TuneBox",
            exclude: [
                "Resources/Info.plist",
                "Preview Content"
            ],
            resources: [
                .process("Resources/Assets.xcassets"),
                .process("Resources/AdditionalInfo.plist")
            ]
        )
    ]
)
