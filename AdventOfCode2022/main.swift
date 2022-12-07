//
//  main.swift
//  AdventOfCode2022
//
//  Created by Nikolay Valasatau on 1.12.22.
//

import Foundation

struct TaskInput {
    var prefix: String = "task"

    func readInput(_ num: String) -> String {
        let name = "\(prefix)\(num)"
        guard let url = Bundle.main.url(forResource: name, withExtension: "txt", subdirectory: "input")
        else {
            fatalError("Not found: input/\(name).txt")
        }
        return try! String(contentsOf: url)
    }
}

// MARK: - Day 01

extension TaskInput {
    func task01() -> [[Int]] {
        readInput("01")
            .split(separator: "\n", omittingEmptySubsequences: false)
            .reduce(into: [[]], { (partialResult, str) in
              if (str.isEmpty) {
                partialResult.append([])
              } else {
                partialResult[partialResult.count - 1].append(Int(str)!)
              }
            })
    }
}

func task01_1(_ input: TaskInput) {
    let elfs = input.task01()
    let max = elfs.map { $0.reduce(0, +) }.max()!
    print("T01_1: \(max)")
}

func task01_2(_ input: TaskInput) {
    let elfs = input.task01()
    let max3 = elfs.map { $0.reduce(0, +) }.sorted().suffix(3).reduce(0, +)
    print("T01_2: \(max3)")
}

// MARK: - Day 02

extension TaskInput {
    enum Task02 {
        enum Figure {
            case rock
            case paper
            case scissors
        }
    }
    func task02() -> [(Task02.Figure, Task02.Figure)] {
        readInput("02")
            .split(separator: "\n")
            .map { line in
                let pair = line.split(separator: " ")
                return (.fromTheir(pair[0]), .fromYour(pair[1]))
            }
    }
}

extension TaskInput.Task02.Figure {
    var score: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scissors:
            return 3
        }
    }
    
    static func fromTheir(_ str: Substring) -> Self {
        switch str {
        case "A":
            return .rock
        case "B":
            return .paper
        case "C":
            return .scissors
        default:
            fatalError()
        }
    }
    
    static func fromYour(_ str: Substring) -> Self {
        switch str {
        case "X":
            return .rock
        case "Y":
            return .paper
        case "Z":
            return .scissors
        default:
            fatalError()
        }
    }
    
    enum Result: Int {
        case win = 6
        case lose = 0
        case draw = 3
    }
    
    func vs(_ other: Self) -> Result {
        switch (self, other) {
        case (.rock, .paper):
            return .lose
        case (.rock, .scissors):
            return .win
        case (.paper, .scissors):
            return .lose
        case (.paper, .rock):
            return .win
        case (.scissors, .rock):
            return .lose
        case (.scissors, .paper):
            return .win
        default:
            return .draw
        }
    }
    
    func how(_ result: Result) -> Self {
        switch (self, result) {
        case (_, .draw):
            return self
        case (.rock, .win):
            return .paper
        case (.rock, .lose):
            return .scissors
        case (.paper, .win):
            return .scissors
        case (.paper, .lose):
            return .rock
        case (.scissors, .win):
            return .rock
        case (.scissors, .lose):
            return .paper
        }
    }
    
    var correctParsing: Result {
        switch self {
        case .rock:
            return .lose
        case .paper:
            return .draw
        case .scissors:
            return .win
        }
    }
}

func task02_1(_ input: TaskInput) {
    let plan = input.task02()
    let score = plan
        .map { (a, b) in b.vs(a).rawValue + b.score }
        .reduce(0, +)
    print("T02_1: \(score)")
}

func task02_2(_ input: TaskInput) {
    let plan = input.task02()
    let score = plan
        .map { (a, b) in (a, b.correctParsing) }
        .map { (a, b) in b.rawValue + a.how(b).score }
        .reduce(0, +)
    print("T02_2: \(score)")
}

// MARK: - Day 03

extension TaskInput {
    enum Task03 {
        static func priority(_ ch: Character) -> Int {
            switch ch {
            case "a"..."z":
                return Int(ch.asciiValue! - "a".first!.asciiValue!) + 1
            case "A"..."Z":
                return Int(ch.asciiValue! - "A".first!.asciiValue!) + 27
            default:
                fatalError()
            }
        }
    }
    
    func task03() -> [([Character], [Character])] {
        readInput("03")
            .split(separator: "\n")
            .map { line in
                let chars = Array(line)
                let half = chars.count / 2
                return (Array(chars.prefix(half)), Array(chars.suffix(half)))
            }
    }
}

func task03_1(_ input: TaskInput) {
    let rsks = input.task03()
    let score = rsks
        .map { (a, b) in Set(a).intersection(Set(b)).first! }
        .map(TaskInput.Task03.priority)
        .reduce(0, +)
    print("T03_1: \(score)")
}

func task03_2(_ input: TaskInput) {
    let rsks = input.task03()
        .map { $0.0 + $0.1 }
        .map(Set.init)
    let groups = (0..<(rsks.count / 3))
        .map { idx -> [Set<Character>] in [rsks[idx * 3], rsks[idx * 3 + 1], rsks[idx * 3 + 2]] }
    let score = groups
        .map { grp -> Character in
            grp[0]
                .intersection(grp[1])
                .intersection(grp[2])
                .first!
        }
        .map(TaskInput.Task03.priority)
        .reduce(0, +)
    print("T03_2: \(score)")
}

// MARK: - Day 04

extension TaskInput {
    enum Task04 {
    }
    
    func task04() -> [(ClosedRange<Int>, ClosedRange<Int>)] {
        readInput("04")
            .split(separator: "\n")
            .map { line in
                let pair = line
                    .split(separator: ",")
                    .map { s in
                        s.split(separator: "-")
                            .map { Int($0)! }
                    }
                    .map { a in ClosedRange(uncheckedBounds: (a[0], a[1])) }
                return (pair[0], pair[1])
            }
    }
}

func task04_1(_ input: TaskInput) {
    let jobs = input.task04()
    let number = jobs
        .filter { (a, b) in
            (a.contains(b.lowerBound) && a.contains(b.upperBound))
            ||
            (b.contains(a.lowerBound) && b.contains(a.upperBound))
        }
        .count
    print("T04_1: \(number)")
}

func task04_2(_ input: TaskInput) {
    let jobs = input.task04()
    let number = jobs
        .filter { (a, b) in
            a.contains(b.lowerBound) || a.contains(b.upperBound)
            ||
            b.contains(a.lowerBound) || b.contains(a.upperBound)
        }
        .count
    print("T04_2: \(number)")
}

// MARK: - Day 05

extension TaskInput {
    enum Task05 {
        struct Move {
            var count: Int
            var fromIdx: Int
            var toIdx: Int
        }

        enum Version {
            case CrateMover9000
            case CrateMover9001
        }

        static func apply(stacks: [[Character]], move: Move, version: Version) -> [[Character]] {
            var movingStack = stacks[move.fromIdx].suffix(move.count)
            if version == .CrateMover9000 {
                movingStack.reverse()
            }
            var result = stacks
            result[move.fromIdx].removeLast(move.count)
            result[move.toIdx].append(contentsOf: movingStack)
            return result
        }

        static func printStacks(_ stacks: [[Character]]) {
            let height = stacks.map(\.count).max()!
            for y in 0..<height {
                print(stacks.map { ($0.count >= height - y) ? "[\($0[height - y - 1])]" : "   " }.joined(separator: " "))
            }
            print((1...stacks.count).map { " \($0) " }.joined(separator: " "))
        }
    }
    
    func task05() -> ([[Character]], [Task05.Move]) {
        let lines = readInput("05")
            .split(separator: "\n")
            .map(Array.init)

        var stacks = [[Character]]()
        var idx = 0
        while lines[idx][1] != "1" {
            let line = lines[idx]
            let stacksCount = (line.count + 1) / 4
            if stacks.count < stacksCount {
                stacks += Array(repeating: [], count: stacksCount - stacks.count)
            }
            for k in 0..<stacksCount {
                let ch = lines[idx][k * 4 + 1]
                if ch != " " {
                    stacks[k].append(ch)
                }
            }
            idx += 1
        }
        stacks = stacks.map { $0.reversed() }

        let moves = lines
            .dropFirst(idx + 1)
            .map { line in
                let parts = line.split(separator: " ").compactMap { Int(String($0)) }
                return Task05.Move(count: parts[0], fromIdx: parts[1] - 1, toIdx: parts[2] - 1)
            }

        return (stacks, moves)
    }
}

func task05_1(_ input: TaskInput) {
    let (stacks, moves) = input.task05()
    let result = moves
        .reduce(stacks) { TaskInput.Task05.apply(stacks: $0, move: $1, version: .CrateMover9000) }
        .compactMap { $0.last }

    print("T05_1: \(String(result))")
}

func task05_2(_ input: TaskInput) {
    let (stacks, moves) = input.task05()
    let result = moves
        .reduce(stacks) { TaskInput.Task05.apply(stacks: $0, move: $1, version: .CrateMover9001) }
        .compactMap { $0.last }

    print("T05_2: \(String(result))")
}

// MARK: - Day 06

extension TaskInput {
    enum Task06 {
        static func findSignal(_ line: Substring, len: Int) -> Int {
            let line = Array(line)
            var cur = " " + line.prefix(len - 1)
            var idx = len - 1
            while idx < line.count {
                cur = cur.dropFirst() + String(line[idx])
                idx += 1
                if Set(cur).count == cur.count {
                    return idx
                }
            }
            return 0
        }
    }

    func task06() -> [Substring] {
        readInput("06")
            .split(separator: "\n")
    }
}

func task06_1(_ input: TaskInput) {
    let lines = input.task06()
    let signals = lines
        .map { TaskInput.Task06.findSignal($0, len: 4) }
    print("T06_1: \(signals)")
}

func task06_2(_ input: TaskInput) {
    let lines = input.task06()
    let signals = lines
        .map { TaskInput.Task06.findSignal($0, len: 14) }
    print("T06_2: \(signals)")
}

// MARK: - Day 07

extension TaskInput {
    enum Task07 {
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

        static func parse(_ cmds: [Substring]) -> Dir
        {
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

        static func dirSizes(_ dir: Dir) -> [String: Int] {
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

        static func printTree(_ dir: Dir) {
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
    }

    func task07() -> Task07.Dir {
        Task07.parse(readInput("07").split(separator: "\n"))
    }
}

extension TaskInput.Task07.Node {
    var name: String {
        switch self {
        case .file(let file):
            return file.name
        case .dir(let dir):
            return dir.name
        }
    }
}

func task07_1(_ input: TaskInput) {
    let root = input.task07()
//    TaskInput.Task07.printTree(root)
    let sizes = TaskInput.Task07.dirSizes(root)
    let result = sizes.values
        .filter { $0 < 100000 }
        .reduce(0, +)
    print("T07_1: \(result)")
}

func task07_2(_ input: TaskInput) {
    let root = input.task07()
    let dirSizes = TaskInput.Task07.dirSizes(root)
    let remainSize = 70000000 - dirSizes[""]!
    let toRemove = 30000000 - remainSize
    let removing = dirSizes.values
        .sorted()
        .first(where: { $0 >= toRemove })!
    print("T07_2: \(removing)")
}

// MARK: - Main

let inputs = [
    TaskInput(prefix: "sample"),
    TaskInput(),
]

for input in inputs {
    print("Run for \(input.prefix)")
    let start = Date()
//    task01_1(input)
//    task01_2(input)

//    task02_1(input)
//    task02_2(input)

//    task03_1(input)
//    task03_2(input)

//    task04_1(input)
//    task04_2(input)

//    task05_1(input)
//    task05_2(input)

//    task06_1(input)
//    task06_2(input)

    task07_1(input)
    task07_2(input)

    print("Time: \(String(format: "%0.4f", -start.timeIntervalSinceNow))")
}
