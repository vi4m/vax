import PackageDescription

let package = Package(
    name: "vax", 
    dependencies: [
        .Package(url: "https://github.com/kylef/Commander.git", majorVersion: 0),
        .Package(url: "https://github.com/vapor/console.git", majorVersion: 1),
        .Package(url: "https://github.com/jdfergason/swift-toml.git", majorVersion: 0, minor: 4)
        ]
)
