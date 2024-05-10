// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoinAPI",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoinAPI",
            targets: ["CoinAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.11.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoinAPI",
            dependencies: ["Alamofire","Kingfisher"]
        ),
        .testTarget(
            name: "CoinAPITests",
            dependencies: ["CoinAPI"]),
    ]
)


