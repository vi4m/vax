//
//  Configuration.swift
//  vax
//
//  Created by Marcin Kliks on 03.01.2017.
//
//

import Foundation
import Toml


final class Configuration {

    var path: String
    var toml: Toml
    static var configName = ".vax.toml"

    init(path: String, toml: Toml) {
        self.path = path
        self.toml = toml
    }

    static func read(path: String) throws -> Configuration {
        let toml = try Toml(contentsOfFile: path)
        return Configuration(path: path, toml: toml)
    }

    static func create(path: String, image: String) throws {
        let initialContents = "image = \"\(image)\"\ntemp_name = \"temp\""
        try initialContents.write(toFile: path, atomically: false, encoding: .utf8)
    }
} 
