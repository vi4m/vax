//
//  VagrantFileParser.swift
//  vax
//
//  Created by Marcin Kliks on 18.01.2017.
//
//

import Foundation
import Regex

public struct VagrantFileParser {
    public static func extractProvisionCommand(s: String) -> String? {
        let greeting = Regex("config.vm.provision.*path:\\s*[\"']+(.*)[\"']+")
        return greeting.match(s)?.captures[0]
    }
}
