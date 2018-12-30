// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "vax",

    dependencies:
    [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/vapor/console.git", from: "3.1.0"),
        .package(url: "https://github.com/vi4m/swift-toml.git", from: "0.4.1"),
        .package(url: "https://github.com/sharplet/Regex.git", from: "0.4.3"),

    ],
    targets: [
        .target(name: "LibVax", dependencies: ["Toml", "Commander", "Console", "Regex"]),
        .target(name: "Vax", dependencies: ["LibVax"]),
    ]
)
