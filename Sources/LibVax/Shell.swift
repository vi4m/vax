//
//  Shell.swift
//  vax
//
//  Created by Marcin Kliks on 03.01.2017.
//
//

import Foundation
import class Console.Terminal


enum CommandError: Error {
    case NonZeroReturnCode
    case FileNotFound
}


public final class Shell {

    static func systemWithTTY(cmd: String, args: [String]) throws {
        
        /// borrowed from Vapor / Console
        func execute(
            program: String,
            arguments: [String],
            input: Int32?,
            output: Int32?,
            error: Int32?
            ) throws {
            var pid = UnsafeMutablePointer<pid_t>.allocate(capacity: 1)
            pid.initialize(to: pid_t())
            defer {
                #if swift(>=4.1)
                pid.deinitialize(count: 1)
                pid.deallocate()
                #else
                pid.deinitialize()
                pid.deallocate(capacity: 1)
                #endif
            }
            
            
            let args = [program] + arguments
            let argv: [UnsafeMutablePointer<CChar>?] = args.map{ $0.withCString(strdup) }
            defer { for case let arg? in argv { free(arg) } }
            
            var environment: [String: String] = ProcessInfo.processInfo.environment
            
            let env: [UnsafeMutablePointer<CChar>?] = environment.map{ "\($0.0)=\($0.1)".withCString(strdup) }
            defer { for case let arg? in env { free(arg) } }
            
            
            #if os(macOS)
            var fileActions: posix_spawn_file_actions_t? = nil
            #else
            var fileActions = posix_spawn_file_actions_t()
            #endif
            
            posix_spawn_file_actions_init(&fileActions);
            defer {
                posix_spawn_file_actions_destroy(&fileActions)
            }
            
            if let input = input {
                posix_spawn_file_actions_adddup2(&fileActions, input, 0)
            }
            
            if let output = output {
                posix_spawn_file_actions_adddup2(&fileActions, output, 1)
            }
            
            if let error = error {
                posix_spawn_file_actions_adddup2(&fileActions, error, 2)
            }
            
            let spawned = posix_spawnp(pid, argv[0], &fileActions, nil, argv + [nil], env + [nil])
            if spawned != 0 {
                    throw CommandError.NonZeroReturnCode
            }
            
            var result: Int32 = 0
            _ = waitpid(pid.pointee, &result, 0)
            result = result / 256
            
            waitpid(pid.pointee, nil, 0)
            
            if result == ENOENT {
                throw CommandError.FileNotFound
            } else if result != 0 {
                throw CommandError.NonZeroReturnCode
            }
        }
        
        try execute(program: cmd, arguments: args, input: STDIN_FILENO, output: STDOUT_FILENO, error: STDERR_FILENO)
    }

    static func system(cmd: String, args: [String], silent: Bool = false) throws {
        let task = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.launchPath = cmd
        task.arguments = args
        let outHandle = outputPipe.fileHandleForReading

        let errorHandle = errorPipe.fileHandleForReading

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

        errorHandle.readabilityHandler = { pipe in
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

        errorHandle.readabilityHandler = nil
        outHandle.readabilityHandler = nil

        let status = task.terminationStatus

        if status != 0 {
            throw CommandError.NonZeroReturnCode
        }
    }

}
