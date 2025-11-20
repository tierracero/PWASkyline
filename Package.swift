// swift-tools-version:5.10

import PackageDescription
import Foundation

// MARK: - Conveniences
struct Dep {
    let package: PackageDescription.Package.Dependency
    let targets: [Target.Dependency]
}

extension Array where Element == Dep {
    
    mutating func appendLocal(_ path: String, targets: Target.Dependency...) {
        append(.init(package: .package(path: "~/Development/Packages/\(path)"), targets: targets))
    }
    
    mutating func append(_ url: String, from: Version, targets: Target.Dependency...) {
        append(.init(package: .package(url: url, from: from), targets: targets))
    }
    
    mutating func appendFromMain(_ url: String, targets: Target.Dependency...) {
        append(
            .init(
                package: .package(url: url, branch: "main"),
                targets: targets
            )
        )
    }
    
    mutating func appendFromMaster(_ url: String, targets: Target.Dependency...) {
        append(
            .init(
                package: .package(url: url, branch: "master"),
                targets: targets
            )
        )
    }
    
    mutating func append(_ url: String, exact: Version, targets: Target.Dependency...) {
        append(
            .init(
                package: .package(url: url, exact: exact),
                targets: targets
            ))
    }
}

var deps: [Dep] = [] 

deps.append("https://github.com/swifweb/web", from: "2.0.0-nightly.5", targets: .product( name: "Web", package: "web"))

deps.appendFromMain("git@github.com:tierracero/TCFundamentals.git",
							 targets: .product(name: "TCFundamentals", package: "TCFundamentals"))

deps.appendFromMain("git@github.com:tierracero/TCFireSignal.git",
							 targets: .product(name: "TCFireSignal", package: "TCFireSignal"))

deps.appendFromMain("git@github.com:tierracero/MailAPICore.git",
                      targets: .product(name: "MailAPICore", package: "MailAPICore"))

deps.appendFromMain("git@github.com:tierracero/TCSocialCore.git",
                      targets: .product(name: "TCSocialCore", package: "TCSocialCore"))

deps.appendFromMain("git@github.com:tierracero/TaecelAPICore.git",
                      targets: .product(name: "TaecelAPICore", package: "TaecelAPICore"))

deps.appendFromMain("git@github.com:tierracero/LanguagePack.git",
                      targets: .product(name: "LanguagePack", package: "LanguagePack"))

deps.appendFromMain("git@github.com:tierracero/WaWebAPICore.git",
                targets: .product(name: "WaWebAPICore", package: "WaWebAPICore"))

let package: Package = Package(
    name: "Tierra Cero | Skyline2.0",
    platforms: [
       .macOS(.v11)
    ],
    products: [
        .executable(name: "App", targets: ["App"]),
        .executable(name: "Service", targets: ["Service"]),
    ],
    dependencies: deps.map{ $0.package },
    targets: [
        .executableTarget(
            name: "App",
            dependencies: deps.flatMap{ $0.targets }
        ),
        .executableTarget(
            name: "Service",
            dependencies: [
                .product(name: "ServiceWorker", package: "web"),
            ],
            resources: [
                .copy("favicon.ico"),
                .copy("skyline/"),
                .copy("images"),
                .copy("js"),
                .copy("css")
            ]),
    ])
