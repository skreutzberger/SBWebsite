import PackageDescription

let package = Package(
    name: "SBWebsite",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 0, minor: 0)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

