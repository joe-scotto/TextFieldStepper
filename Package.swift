//swift-tools-version:5.5.0

import PackageDescription

let package = Package(
    name: "TextFieldStepper",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TextFieldStepper",
            targets: ["TextFieldStepper"]),
    ],
    targets: [
        .target(
            name: "TextFieldStepper",
            dependencies: []),
    ]
)
