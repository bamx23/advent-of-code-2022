//
//  Day05.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

struct Day05: Day {
    var input: String
    
    struct Move {
        var count: Int
        var fromIdx: Int
        var toIdx: Int
    }

    enum Version {
        case CrateMover9000
        case CrateMover9001
    }
    
    func parse() -> ([[Character]], [Move]) {
        let lines = input
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
                return Move(count: parts[0], fromIdx: parts[1] - 1, toIdx: parts[2] - 1)
            }

        return (stacks, moves)
    }
    
    func apply(stacks: [[Character]], move: Move, version: Version) -> [[Character]] {
        var movingStack = stacks[move.fromIdx].suffix(move.count)
        if version == .CrateMover9000 {
            movingStack.reverse()
        }
        var result = stacks
        result[move.fromIdx].removeLast(move.count)
        result[move.toIdx].append(contentsOf: movingStack)
        return result
    }

    func printStacks(_ stacks: [[Character]]) {
        let height = stacks.map(\.count).max()!
        for y in 0..<height {
            print(stacks.map { ($0.count >= height - y) ? "[\($0[height - y - 1])]" : "   " }.joined(separator: " "))
        }
        print((1...stacks.count).map { " \($0) " }.joined(separator: " "))
    }
    
    func part01() {
        let (stacks, moves) = parse()
        let result = moves
            .reduce(stacks) { apply(stacks: $0, move: $1, version: .CrateMover9000) }
            .compactMap { $0.last }

        print(result)
    }
    
    func part02() {
        let (stacks, moves) = parse()
        let result = moves
            .reduce(stacks) { apply(stacks: $0, move: $1, version: .CrateMover9001) }
            .compactMap { $0.last }

        print(result)
    }
}
