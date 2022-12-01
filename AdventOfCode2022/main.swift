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

// MARK: - Main

let inputs = [
    TaskInput(prefix: "sample"),
    TaskInput(),
]

for input in inputs {
    print("Run for \(input.prefix)")
    let start = Date()
    task01_1(input)
    task01_2(input)

    print("Time: \(String(format: "%0.4f", -start.timeIntervalSinceNow))")
}
