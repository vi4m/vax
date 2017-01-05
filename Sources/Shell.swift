//
//  Shell.swift
//  vax
//
//  Created by Marcin Kliks on 03.01.2017.
//
//

import Foundation
import class Console.Terminal


final class Shell {

    static func systemWithTTY(cmd: String, args: [String]) throws {
        return try Terminal(arguments: []).execute(program: cmd, arguments: args)
    }

    static func system(cmd: String, args: [String], silent: Bool = false) {
        let task = Process()
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        task.launchPath = cmd
        task.arguments = args
        let outHandle = outputPipe.fileHandleForReading

        outHandle.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
                // Update your view with the new text here
                if !silent {
                    print(line, terminator: "")
                }
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
        }
        task.launch()
        task.waitUntilExit()
    }

}
