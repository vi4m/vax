import Commander
import Foundation

// FIXME: write native API client


enum ConfigurationError: Error {
    case InitializeError
    case CannotReadError
}


let g = Group {


    let pwd: NSString = FileManager.default.currentDirectoryPath as NSString
    let final = pwd.appendingPathComponent(Configuration.configName)


    $0.command("run") {
        guard let conf = try? Configuration.read(path: final) else {
            print("Cannot read configuration file")
            exit(2)
        }
        guard let name = conf.toml.string("image"),
            let temporary = conf.toml.string("temp_name")
            else {
                print("Configuration file is empty")
                exit(3)
        }
        let docker = DockerShellProvider()
        try? docker.remove(name: temporary)
        do {
            try docker.run(image: name, temporaryContainerName: temporary)
            try docker.commit(name: temporary, image: name)
        } catch {
            print(error)
            exit(4)
        }
    }

    $0.command("init") { (imageName: String) in
        do {
            try Configuration.create(path: final, image: imageName)
        } catch {
            print("Can't write")
        }
    }
}

g.run()

