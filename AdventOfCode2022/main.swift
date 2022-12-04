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
    
    task04_1(input)
    task04_2(input)

    print("Time: \(String(format: "%0.4f", -start.timeIntervalSinceNow))")
}
