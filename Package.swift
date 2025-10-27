// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorWorkoutkit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CapacitorWorkoutkit",
            targets: ["WorkoutkitPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "WorkoutkitPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/WorkoutkitPlugin"),
        .testTarget(
            name: "WorkoutkitPluginTests",
            dependencies: ["WorkoutkitPlugin"],
            path: "ios/Tests/WorkoutkitPluginTests")
    ]
)