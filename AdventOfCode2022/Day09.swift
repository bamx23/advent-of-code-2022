//
//  Day09.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

struct Day09: Day {
    var input: String
    
    enum Move: String {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"
    }
    
    typealias Pos = (x: Int, y: Int)
    
    func parse() -> [(Move, Int)] {
        input
            .split(separator: "\n")
            .map { line in
                let pair = line.split(separator: " ")
                return (.init(rawValue: String(pair[0]))!, Int(pair[1])!)
            }
    }
    
    func moveHead(head: Pos, move: Move) -> Pos {
        let dir = move.dir
        let newHead: Pos = (x: head.x + dir.x, y: head.y + dir.y)
        return newHead
    }
    
    func followHead(head: Pos, tail: Pos) -> Pos {
        let delta: Pos = (x: head.x - tail.x, y: head.y - tail.y)
        
        func short(_ delta: Int) -> Int {
            if delta >= 1 { return 1 }
            if delta <= -1 { return -1 }
            return 0
        }
        
        switch delta {
        case (x: 0, y: 0):
            return head
        case (x: 0, y: let y) where y != 0:
            return (x: head.x, y: head.y - short(y))
        case (x: let x, y: 0) where x != 0:
            return (x: head.x - short(x), y: head.y)
        case (x: let x, y: let y) where abs(x) == 1 && abs(y) == 1:
            return tail
        case (x: let x, y: let y) where abs(x) == 1 && abs(y) == 2:
            return (x: head.x, y: head.y - short(y))
        case (x: let x, y: let y) where abs(x) == 2 && abs(y) == 1:
            return (x: head.x - short(x), y: head.y)
        case (x: let x, y: let y) where abs(x) == 2 && abs(y) == 2:
            return (x: head.x - short(x), y: head.y - short(y))
        default:
            fatalError()
        }
    }
    
    func printField(rope: [Pos], size: (Int, Int)) {
        for y in (0..<size.0).reversed() {
            var line = ""
            for x in (0..<size.1) {
                var found = false
                for (idx, p) in rope.enumerated() {
                    if x == p.x && y == p.y {
                        if idx == 0 {
                            line += "H"
                        } else if idx == rope.count - 1 {
                            line += "T"
                        } else {
                            line += "\(idx)"
                        }
                        found = true
                        break
                    }
                }
                if (found) {
                    continue
                }
                if (x == 0 && y == 0) {
                    line += "s"
                    continue
                }
                line += "."
            }
            print(line)
        }
    }
    
    func part01() {
        let moves = parse()
        var head: Pos = (x: 0, y: 0)
        var tail = head
        var visited = [0: [0: 1]]
        for (move, count) in moves {
//            print("\n== \(move.rawValue) \(count) ==\n")
            for _ in 0..<count {
                head = moveHead(head: head, move: move)
                tail = followHead(head: head, tail: tail)
                visited[tail.y, default: [:]][tail.x, default: 0] += 1
//                printField(rope: [head, tail], size: (6, 6))
//                print("")
            }
        }
        let numVisited = visited.values.map(\.count).reduce(0, +)
        print(numVisited)
    }
    
    func part02() {
        let moves = parse()
        let len = 10
        var rope: [Pos] = .init(repeating: (0, 0), count: len)
        var visited = [0: [0: 1]]
        for (move, count) in moves {
//            print("\n== \(move.rawValue) \(count) ==\n")
            for _ in 0..<count {
                var newRope = rope
                newRope[0] = moveHead(head: rope[0], move: move)
                for idx in 1..<len {
                    newRope[idx] = followHead(head: newRope[idx - 1], tail: newRope[idx])
                }
                rope = newRope
                visited[rope.last!.y, default: [:]][rope.last!.x, default: 0] += 1
//                printField(rope: rope, size: (6, 6))
//                print("")
            }
        }
        let numVisited = visited.values.map(\.count).reduce(0, +)
        print(numVisited)
    }
}

extension Day09.Move {
    var dir: Day09.Pos {
        switch self {
        case .right:
            return (1, 0)
        case .left:
            return (-1, 0)
        case .down:
            return (0, -1)
        case .up:
            return (0, 1)
        }
    }
}
