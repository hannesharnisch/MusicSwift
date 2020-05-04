// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MusicSwift",
    platforms: [.iOS(.v13)], products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MusicSwift",
            targets: ["MusicSwift"]),
        .library(
            name: "NowPlayingView",
                 targets: ["NowPlayingView"])
    ],
    dependencies: [
        .package(name: "SwiftJWT", url: "https://github.com/IBM-Swift/Swift-JWT.git", from: "3.6.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MusicSwift",
            dependencies: ["SwiftJWT"]),
        .target(
            name: "NowPlayingView",
            dependencies: ["MusicSwift"]),
        .testTarget(
            name: "MusicSwiftTests",
            dependencies: ["MusicSwift"]),
    ]
)
