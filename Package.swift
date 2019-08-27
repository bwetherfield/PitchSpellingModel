// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PitchSpellingModel",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "PitchSpellingModel",
            targets: ["PitchSpellingModel"]),
        .library(
            name: "NetworkStructures",
            targets: ["NetworkStructures"]),
        .library(
            name: "Encodings",
            targets: ["Encodings"]),
    ],
    dependencies: [
        .package(url: "https://github.com/dn-m/Structure", .branch("pitchspeller-dependency")),
        .package(url: "https://github.com/dn-m/Music", from: "0.15.0"),
        .package(url: "https://github.com/dn-m/NotationModel", from: "0.8.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PitchSpellingModel",
            dependencies: []),
        .target(
            name: "NetworkStructures",
            dependencies: []),
        .target(
            name: "Encodings",
            dependencies: ["Pitch", "SpelledPitch", "DataStructures"]),
        .testTarget(
            name: "PitchSpellingModelTests",
            dependencies: ["PitchSpellingModel"]),
    ]
)
