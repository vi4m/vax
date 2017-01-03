//
//  DockerProvider.swift
//  vax
//
//  Created by Marcin Kliks on 03.01.2017.
//
//

import Foundation


protocol DockerProvider {
    func run(image: String, temporaryContainerName: String) throws
    func remove(name: String) throws
    func commit(name: String, image: String) throws
}


class DockerShellProvider: DockerProvider {

    var dockerCommand: String

    init(dockerCommand: String = "/usr/local/bin/docker") {
        self.dockerCommand = dockerCommand
    }

    func run(image: String, temporaryContainerName: String) throws {
        let args = ("run -ti --name \(temporaryContainerName) " +
            "--privileged \(image)").components(separatedBy: " ")
        try Shell.systemWithTTY(cmd: dockerCommand, args: args)
    }

    func remove(name: String) throws {
        let cmd = "/usr/local/bin/docker"
        let args = "rm \(name)".components(separatedBy: " ")
        Shell.system(cmd: cmd, args: args)
    }

    func commit(name: String, image repository: String) throws {
        let cmd = "/usr/local/bin/docker"
        let args = "commit \(name) \(repository)".components(separatedBy: " ")
        Shell.system(cmd: cmd, args: args)
    }

}
