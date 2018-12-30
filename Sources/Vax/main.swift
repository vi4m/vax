import Commander
import Foundation
import LibVax

enum ConfigurationError: Error {
    case InitializeError
    case CannotReadError
}

let g = Group {
    var pwd = URL(string: FileManager.default.currentDirectoryPath)!
    var configPath = pwd.appendingPathComponent(Configuration.configName)

    if !FileManager.default.fileExists(atPath: configPath.path) {
        if #available(OSX 10.12, *) {
            configPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(Configuration.configName)
        } else {
            fatalError()
        }
    }

    $0.command("vagrant_run", description: "Run vagrant") { (vagrantFile: String) in
        guard let fileContents = try? String(contentsOfFile: vagrantFile) else {
            print("Cannot read file")
            exit(3)
        }
        guard let provisionCommand = VagrantFileParser.extractProvisionCommand(s: fileContents) else {
            print("Cannot find provision command")
            exit(4)
        }

        print(provisionCommand)

        let docker = DockerShellProvider()

//        try docker.runContainer(image: "ubuntu:16.04", temporaryContainerName: "vagrant_temp", command: "", fromVolume: <#String#>)
//        try docker.commit(name: config.temporaryName, image: config.destImage)
    }

    $0.command("list") {
        guard let config = try? Configuration.read(path: configPath) else {
            print("Cannot read configuration file")
            exit(2)
        }
    }

    $0.command("run") { (caption: String) in

        guard let config = try? Configuration.read(path: configPath) else {
            print("Cannot read configuration file")
            exit(2)
        }

        guard let entry = config.containers[caption] else {
            print("Cannot find entry")
            exit(0)
        }

        let docker = DockerShellProvider()
        try? docker.removeContainer(name: entry.caption + "_temp")
        do {
            try docker.runContainerInteractive(image: entry.caption,
                                               temporaryContainerName: entry.caption + "_temp", fromVolume: pwd.path, toVolume: "/mounted")

            try docker.commit(name: entry.caption + "_temp", image: entry.caption)
        } catch {
            print(error)
            exit(4)
        }
        exit(0)
    }

    $0.command("init") { (image: String, caption: String) in
        do {
            var config = (try? Configuration.read(path: configPath)) ?? Containers(containers: [:])

            let entry = Container(caption: caption, image: image)

            let docker = DockerShellProvider()
            try? docker.removeImage(name: entry.caption)
            try? docker.removeContainer(name: entry.caption + "_temp")

            try docker.runContainer(image: entry.image,
                                    temporaryContainerName: entry.caption + "_temp",
                                    command: "echo \"Init...\"",
                                    fromVolume: "/Users/marcinkliks",
                                    toVolume: "/opt")
            try docker.commit(name: entry.caption + "_temp", image: entry.caption)
            config.containers[caption] = entry
            try Configuration.save(path: configPath, containers: config)
        } catch {
            print("Cannot initialize.")
        }
    }
}

g.run()
