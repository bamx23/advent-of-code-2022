//
//  Day07.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day07: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    class Dir {
        let name: String
        var nodes: [Node] = []

        init(name: String) {
            self.name = name
        }
    }
    
    struct File {
        var name: String
        var size: Int
    }
    
    enum Node {
        case dir(Dir)
        case file(File)
    }
    
    func parse() -> Dir
    {
        let cmds = input.split(separator: "\n")
        if cmds.isEmpty || cmds[0] != "$ cd /" {
            fatalError()
        }
        let rootDir = Dir(name: "")
        var dirStack = [rootDir]
        var idx = 1
        while idx < cmds.count {
            let cmd = cmds[idx]

            // ls command
            if cmd == "$ ls" {
                var nodes = [Node]()
                idx += 1
                while idx < cmds.count && !cmds[idx].hasPrefix("$") {
                    let parts = cmds[idx].split(separator: " ")
                    let name = String(parts[1])
                    if parts[0] == "dir" {
                        nodes.append(.dir(.init(name: name)))
                    } else {
                        nodes.append(.file(.init(name: name, size: Int(parts[0])!)))
                    }
                    idx += 1
                }
                dirStack.last!.nodes = nodes
                continue
            }

            // cd command
            if cmd.hasPrefix("$ cd") {
                let name = cmd.split(separator: " ").last!

                if name == ".." {
                    dirStack.removeLast()
                } else {
                    let nextDir = dirStack.last!.nodes
                        .compactMap { if case .dir(let dir) = $0 { return dir } else { return nil } }
                        .first(where: { $0.name == name })!
                    dirStack.append(nextDir)
                }
                idx += 1
            }
        }
        return rootDir
    }

    func dirSizes(_ dir: Dir) -> [String: Int] {
        var result = [String: Int]()

        func rec(_ dir: Dir, path: String) -> Int {
            var thisSize = 0
            for node in dir.nodes {
                switch node {
                case .file(let file):
                    thisSize += file.size
                case .dir(let dir):
                    thisSize += rec(dir, path: "\(path)/\(dir.name)")
                }
            }
            result[path] = thisSize
            return thisSize
        }

        _ = rec(dir, path: "")
        return result
    }

    func printTree(_ dir: Dir) {
        func rec(_ dir: Dir, prefix: String) {
            for node in dir.nodes.sorted(by: { (a,b) in a.name < b.name }) {
                switch node {
                case .file(let file):
                    print("\(prefix)- \(file.name) (file, size=\(file.size))")
                case .dir(let subdir):
                    print("\(prefix)- \(subdir.name) (dir)")
                    rec(subdir, prefix: prefix + "  ")
                }
            }
        }
        print("- / (dir)")
        rec(dir, prefix: "  ")
    }
    
    public func part01() {
        let root = parse()
//        printTree(root)
        let sizes = dirSizes(root)
        let result = sizes.values
            .filter { $0 < 100000 }
            .reduce(0, +)
        print(result)
    }
    
    public func part02() {
        let root = parse()
        let dirSizes = dirSizes(root)
        let remainSize = 70000000 - dirSizes[""]!
        let toRemove = 30000000 - remainSize
        let removing = dirSizes.values
            .sorted()
            .first(where: { $0 >= toRemove })!
        print(removing)
    }
}

extension Day07.Node {
    var name: String {
        switch self {
        case .file(let file):
            return file.name
        case .dir(let dir):
            return dir.name
        }
    }
}
