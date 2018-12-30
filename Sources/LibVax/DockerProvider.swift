//
//  DockerProvider.swift
//  vax
//
//  Created by Marcin Kliks on 03.01.2017.
//
//

import Foundation

protocol DockerProvider {
    func runContainer(image: String, temporaryContainerName: String, command: String, fromVolume: String, toVolume: String) throws
    func runContainerInteractive(image: String, temporaryContainerName: String, fromVolume: String, toVolume: String) throws
    func removeContainer(name: String) throws
    func removeImage(name: String) throws
    func commit(name: String, image: String) throws
}

// FIXME: make it api in the future.

public class DockerShellProvider: DockerProvider {
    var dockerCommand: String

    public init(dockerCommand: String = "/usr/local/bin/docker") {
        self.dockerCommand = dockerCommand
    }

    public func runContainer(image: String, temporaryContainerName: String, command: String,
                             fromVolume: String, toVolume: String) throws {
        let volumeString = "\(fromVolume):\(toVolume)"
        let args = ("run --name \(temporaryContainerName) " +
            "--privileged -v \(volumeString) \(image) \(command)").components(separatedBy: " ")
        try Shell.system(cmd: dockerCommand, args: args)
    }

    public func runContainerInteractive(image: String, temporaryContainerName: String, fromVolume: String, toVolume: String) throws {
        let volumeString = "\(fromVolume):\(toVolume)"

        let args = ("run -ti --name \(temporaryContainerName) " +
            "--privileged -v \(volumeString) \(image) /bin/bash").components(separatedBy: " ")
        try Shell.systemWithTTY(cmd: dockerCommand, args: args)
    }

    public func removeContainer(name: String) throws {
        let args = "rm -f \(name)".components(separatedBy: " ")
        try Shell.system(cmd: dockerCommand, args: args, silent: true)
    }

    public func removeImage(name: String) throws {
        let args = "rmi \(name)".components(separatedBy: " ")
        try Shell.system(cmd: dockerCommand, args: args, silent: true)
    }

    public func commit(name: String, image repository: String) throws {
        let cmd = "/usr/local/bin/docker"
        let args = "commit \(name) \(repository)".components(separatedBy: " ")
        try Shell.system(cmd: cmd, args: args, silent: true)
    }
}
