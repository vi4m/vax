//
//  Configuration.swift
//  vax
//
//  Created by Marcin Kliks on 03.01.2017.
//
//

import Foundation
// import Toml

public struct Container: Codable {
    public var caption: String
    public var image: String

    public init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
}

public struct Containers: Codable {
    public init(containers: [String: Container]) {
        self.containers = containers
    }

    public var containers: [String: Container]
}

public final class Configuration {
    var path: String

    public static var configName = ".vax.toml"

    public init(path: String, sourceImage _: String, destImage _: String, temporaryName _: String) {
        self.path = path
    }

    public static func read(path: URL) throws -> Containers {
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: path)
        return try decoder.decode(Containers.self, from: data)
    }

    public static func save(path: URL, containers: Containers) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let output = try encoder.encode(containers)
        try output.write(to: path)
    }
}
