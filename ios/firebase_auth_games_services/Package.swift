// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "firebase_auth_games_services",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(
            name: "firebase-auth-games-services",
            targets: ["firebase_auth_games_services"]
        )
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "firebase_auth_games_services",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: []
        )
    ]
)
