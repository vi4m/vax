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
    var sourceImage: String
    var destImage: String
    var temporaryName: String

    static var configName = ".vax.toml"

    init(path: String, sourceImage: String, destImage: String, temporaryName: String) {
        self.path = path
        self.sourceImage = sourceImage
        self.destImage = destImage
        self.temporaryName = temporaryName
    }

    static func read(path: String) throws -> Configuration {
        let toml = try Toml(contentsOfFile: path)

        guard let sourceImage = toml.string("source_image"),
            let destImage = toml.string("dest_image"),
            let temporaryName = toml.string("temp_name")
        else {
                print("Configuration file is invalid. Reinit with vax init.")
                exit(3)
        }
        return Configuration(path: path, sourceImage: sourceImage, destImage: destImage, temporaryName: temporaryName)
    }

    static func create(path: String, sourceImage: String, destImage: String) throws {
        let initialContents = "source_image = \"\(sourceImage)\"" +
            "\ntemp_name = \"temp_\(destImage)\"" +
            "\ndest_image = \"\(destImage)\""
        try initialContents.write(toFile: path, atomically: false, encoding: .utf8)
    }
} 
