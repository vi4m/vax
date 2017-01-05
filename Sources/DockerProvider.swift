//
//  DockerProvider.swift
//  vax
//
//  Created by Marcin Kliks on 03.01.2017.
//
//

import Foundation

protocol DockerProvider {
    func runContainer(image: String, temporaryContainerName: String, command: String) throws
    func runContainerInteractive(image: String, temporaryContainerName: String) throws
    func removeContainer(name: String) throws
    func removeImage(name: String) throws
    func commit(name: String, image: String) throws
}

//FIXME: make it api in the future.

class DockerShellProvider: DockerProvider {

    var dockerCommand: String

    init(dockerCommand: String = "/usr/local/bin/docker") {
        self.dockerCommand = dockerCommand
    }
    
    func runContainer(image: String, temporaryContainerName: String, command: String) throws {
        let args = ("run --name \(temporaryContainerName) " +
            "--privileged \(image) \(command)").components(separatedBy: " ")
        try Shell.system(cmd: dockerCommand, args: args)
    }
    func runContainerInteractive(image: String, temporaryContainerName: String) throws {
        let args = ("run -ti --name \(temporaryContainerName) " +
            "--privileged \(image) /bin/bash").components(separatedBy: " ")
        try Shell.systemWithTTY(cmd: dockerCommand, args: args)
    }

    func removeContainer(name: String) throws {
        let args = "rm \(name)".components(separatedBy: " ")
        try Shell.system(cmd: dockerCommand, args: args, silent: true)
    }
    
    func removeImage(name: String) throws {
        let args = "rmi \(name)".components(separatedBy: " ")
        try Shell.system(cmd: dockerCommand, args: args, silent: true)
    }

    func commit(name: String, image repository: String) throws {
        let cmd = "/usr/local/bin/docker"
        let args = "commit \(name) \(repository)".components(separatedBy: " ")
        try Shell.system(cmd: cmd, args: args, silent: true)
    }

}
