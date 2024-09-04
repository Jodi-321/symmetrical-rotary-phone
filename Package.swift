// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "journalApp",
    platforms: [
        .iOS(.v13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        .target(
            name: "journalApp",
            dependencies: ["Swinject"]
        ),
        .testTarget(
            name: "journalAppTests",
            dependencies: ["journalApp"]
        )
    ]
)
