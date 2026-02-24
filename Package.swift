// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClosetWeek",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "ClosetWeek", targets: ["ClosetWeek"])
    ],
    targets: [
        .target(name: "ClosetWeek", path: "Sources/ClosetWeek"),
        .testTarget(name: "ClosetWeekTests", dependencies: ["ClosetWeek"], path: "Tests/ClosetWeekTests")
    ]
)
