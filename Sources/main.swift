import Commander
import Foundation


enum ConfigurationError: Error {
    case InitializeError
    case CannotReadError
}


let g = Group {


    let pwd: NSString = FileManager.default.currentDirectoryPath as NSString
    let final = pwd.appendingPathComponent(Configuration.configName)


    $0.command("run") {
        guard let config = try? Configuration.read(path: final) else {
            print("Cannot read configuration file")
            exit(2)
        }
        
        let docker = DockerShellProvider()
        try? docker.remove(name: config.temporaryName)
        do {
            try docker.runContainerInteractive(image: config.destImage, temporaryContainerName: config.temporaryName)
            try docker.commit(name: config.temporaryName, image: config.destImage)
        } catch {
            print(error)
            exit(4)
        }
        exit(0)
    }

    $0.command("init") { (sourceImage: String, destImage: String) in
        do {
            try Configuration.create(path: final, sourceImage: sourceImage, destImage: destImage)

            guard let config = try? Configuration.read(path: final) else {
               print("Couldn't read config file")
               exit(4)
            }

            let docker = DockerShellProvider()
            try? docker.remove(name: config.destImage)
            try? docker.remove(name: config.temporaryName)
            
            try docker.runContainer(image: config.destImage, temporaryContainerName: config.temporaryName, command: "echo \"Init...\"")
            try docker.commit(name: config.temporaryName, image: config.destImage)
            
        } catch {
            print("Can't write")
        }
    }
}

g.run()

