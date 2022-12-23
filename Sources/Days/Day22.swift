//
//  Day22.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 21/12/2022.
//

import Foundation
import Shared

public struct Day22: Day {
    static public let number = 22

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    enum Move {
        case fwd(Int)
        case left
        case right
    }
    
    enum Dir: CaseIterable {
        case right
        case down
        case left
        case up
        
        var diff: Pos {
            switch self {
            case .right:
                return .init(x: 1, y: 0)
            case .left:
                return .init(x: -1, y: 0)
            case .down:
                return .init(x: 0, y: 1)
            case .up:
                return .init(x: 0, y: -1)
            }
        }
        
        var rotLeft: Self {
            switch self {
            case .right:
                return .up
            case .down:
                return .right
            case .left:
                return .down
            case .up:
                return .left
            }
        }
        
        var rotRight: Self {
            switch self {
            case .right:
                return .down
            case .down:
                return .left
            case .left:
                return .up
            case .up:
                return .right
            }
        }
        
        var score: Int {
            switch self {
            case .right:
                return 0
            case .down:
                return 1
            case .left:
                return 2
            case .up:
                return 3
            }
        }
        
        var symbol: String {
            switch self {
            case .right:
                return ">"
            case .down:
                return "v"
            case .left:
                return "<"
            case .up:
                return "^"
            }
        }
    }
    
    enum Tile {
        case no
        case wall
        case open
        
        var symbol: String {
            switch self {
            case .no:
                return " "
            case .wall:
                return "#"
            case .open:
                return "."
            }
        }
    }
    
    typealias Map = [[Tile]]
    
    func parse() -> (Map, [Move]) {
        let lines = input.split(separator: "\n")
        var map = lines
            .dropLast()
            .map { line in
                line.map { ch -> Tile in
                    switch ch {
                    case " ":
                        return .no
                    case ".":
                        return .open
                    case "#":
                        return .wall
                    default:
                        fatalError()
                    }
                }
            }
        let width = map.map(\.count).max()!
        map = map.map { row in
            if row.count < width {
                return row + .init(repeating: .no, count: width - row.count)
            } else {
                return row
            }
        }
        let moves = lines.last!.reduce(into: [Move]()) { partialResult, ch in
            switch ch {
            case "L":
                partialResult.append(.left)
            case "R":
                partialResult.append(.right)
            case "0"..."9":
                if case .fwd(let num) = partialResult.last {
                    partialResult[partialResult.count - 1] = .fwd(num * 10 + ch.wholeNumberValue!)
                } else {
                    partialResult.append(.fwd(ch.wholeNumberValue!))
                }
            default:
                fatalError()
            }
        }
        return (map, moves)
    }
    
    func initialPos(map: Map) -> Pos {
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == .open {
                    return .init(x: x, y: y)
                }
            }
        }
        fatalError()
    }
    
    func opposite(pos: Pos, dir: Dir, map: Map) -> Pos {
        switch dir {
        case .right:
            return .init(x: map[pos.y].enumerated().first(where: { (_, t) in t != .no })!.offset, y: pos.y)
        case .down:
            return .init(x: pos.x, y: map.enumerated().first(where: { (_, t) in t[pos.x] != .no })!.offset)
        case .left:
            return .init(x: map[pos.y].enumerated().reversed().first(where: { (_, t) in t != .no })!.offset, y: pos.y)
        case .up:
            return .init(x: pos.x, y: map.enumerated().reversed().first(where: { (_, t) in t[pos.x] != .no })!.offset)
        }
    }
    
    func onCube(pos: Pos, dir: Dir, map: Map) -> (Pos, Dir) {
        var newPos = pos
        var newDir = dir
        if map.count == 12 {
            /*
             --x-
             xxx-
             --xx
             
             y: 0 4 8
             x: 0 4 8 12
             */
            switch dir {
            case .right:
                switch (pos.y / 4) {
                case 0:
                    newPos = .init(x: 15, y: 11 - pos.y)
                    newDir = .left
                case 1:
                    newPos = .init(x: 12 + (7 - pos.y), y: 8)
                    newDir = .down
                case 2:
                    newPos = .init(x: 11, y: 11 - pos.y)
                    newDir = .left
                default:
                    fatalError()
                }
            case .down:
                switch (pos.x / 4) {
                case 0:
                    newPos = .init(x: 8 + (3 - pos.x), y: 11)
                    newDir = .up
                case 1:
                    newPos = .init(x: 8, y: 11 - (pos.x - 4))
                    newDir = .right
                case 2:
                    newPos = .init(x: 11 - pos.x, y: 7)
                    newDir = .up
                case 3:
                    newPos = .init(x: 0, y: 4 + (15 - pos.x))
                    newDir = .right
                default:
                    fatalError()
                }
            case .left:
                switch (pos.y / 4) {
                case 0:
                    newPos = .init(x: 4 + pos.y, y: 4)
                    newDir = .down
                case 1:
                    newPos = .init(x: 15 - (pos.y - 4), y: 11)
                    newDir = .up
                case 2:
                    newPos = .init(x: 4 + (11 - pos.y), y: 7)
                    newDir = .up
                default:
                    fatalError()
                }
            case .up:
                switch (pos.x / 4) {
                case 0:
                    newPos = .init(x: 8 + (3 - pos.x), y: 0)
                    newDir = .down
                case 1:
                    newPos = .init(x: 8, y: pos.x - 4)
                    newDir = .right
                case 2:
                    newPos = .init(x: 11 - pos.x, y: 4)
                    newDir = .down
                case 3:
                    newPos = .init(x: 11, y: 4 + (15 - pos.x))
                    newDir = .left
                default:
                    fatalError()
                }
            }
        } else {
            switch dir {
                
                /*
                 -xx    -01
                 -x-    -2-
                 xx-    34-
                 x--    5--
                 
                 y: 0 50 100 150 200
                 x: 0 50 100 150
                 */
            case .right:
                switch (pos.y / 50) {
                case 0:
                    newPos = .init(x: 99, y: 100 + (49 - pos.y))
                    newDir = .left
                case 1:
                    newPos = .init(x: 100 + pos.y - 50, y: 49)
                    newDir = .up
                case 2:
                    newPos = .init(x: 149, y: 149 - pos.y)
                    newDir = .left
                case 3:
                    newPos = .init(x: 50 + pos.y - 150, y: 149)
                    newDir = .up
                default:
                    fatalError()
                }
            case .down:
                switch (pos.x / 50) {
                case 0:
                    newPos = .init(x: 100 + pos.x, y: 0)
                    newDir = .down
                case 1:
                    newPos = .init(x: 49, y: 150 + (pos.x - 50))
                    newDir = .left
                case 2:
                    newPos = .init(x: 99, y: 50 + (pos.x - 100))
                    newDir = .left
                default:
                    fatalError()
                }
            case .left:
                switch (pos.y / 50) {
                case 0:
                    newPos = .init(x: 0, y: 149 - pos.y)
                    newDir = .right
                case 1:
                    newPos = .init(x: pos.y - 50, y: 100)
                    newDir = .down
                case 2:
                    newPos = .init(x: 50, y: 149 - pos.y)
                    newDir = .right
                case 3:
                    newPos = .init(x: 50 + (pos.y - 150), y: 0)
                    newDir = .down
                default:
                    fatalError()
                }
            case .up:
                switch (pos.x / 50) {
                case 0:
                    newPos = .init(x: 50, y: 50 + pos.x)
                    newDir = .right
                case 1:
                    newPos = .init(x: 0, y: 150 + (pos.x - 50))
                    newDir = .right
                case 2:
                    newPos = .init(x: pos.x - 100, y: 199)
                    newDir = .up
                default:
                    fatalError()
                }
            }
        }
        return (newPos, newDir)
    }
    
    func printMap(_ map: Map, moves: [Pos: Dir]) {
        var result = ""
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if let dir = moves[.init(x: x, y: y)] {
                    result += dir.symbol
                } else {
                    result += map[y][x].symbol
                }
            }
            result += "\n"
        }
        print(result)
    }
    
    public func part01() -> String {
        let (map, moves) = parse()
        var visualMoves = [Pos: Dir]()
        var pos = initialPos(map: map)
        var dir: Dir = .right
        for move in moves {
            switch move {
            case .right:
                dir = dir.rotRight
            case .left:
                dir = dir.rotLeft
            case .fwd(let steps):
                let diff = dir.diff
                for _ in 0..<steps {
                    visualMoves[pos] = dir
                    var newPos = pos + diff
                    if !(0 <= newPos.x && newPos.x < map[0].count && 0 <= newPos.y && newPos.y < map.count && map[newPos.y][newPos.x] != .no) {
                        newPos = opposite(pos: pos, dir: dir, map: map)
                    }
                    if map[newPos.y][newPos.x] == .wall {
                        break
                    }
                    pos = newPos
                }
//                printMap(map, moves: visualMoves)
            }
        }
        return "\(1000 * (pos.y + 1) + 4 * (pos.x + 1) + dir.score)"
    }
    
    func testMap(map: Map) {
        guard map.count != 12 else { return }
        let tests: [(Pos, Dir, Pos, Dir)] = [
            (.init(x: 75, y: 0), .up, .init(x: 0, y: 175), .right),
            (.init(x: 125, y: 0), .up, .init(x: 25, y: 199), .up),
            (.init(x: 149, y: 25), .right, .init(x: 99, y: 124), .left),
            (.init(x: 125, y: 49), .down, .init(x: 99, y: 75), .left),
            (.init(x: 99, y: 75), .right, .init(x: 125, y: 49), .up),
            (.init(x: 99, y: 125), .right, .init(x: 149, y: 24), .left),
            (.init(x: 75, y: 149), .down, .init(x: 49, y: 175), .left),
            (.init(x: 49, y: 175), .right, .init(x: 75, y: 149), .up),
            (.init(x: 25, y: 199), .down, .init(x: 125, y: 0), .down),
            (.init(x: 0, y: 175), .left, .init(x: 75, y: 0), .down),
            (.init(x: 0, y: 125), .left, .init(x: 50, y: 24), .right),
            (.init(x: 25, y: 100), .up, .init(x: 50, y: 75), .right),
            (.init(x: 50, y: 75), .left, .init(x: 25, y: 100), .down),
            (.init(x: 50, y: 25), .left, .init(x: 0, y: 124), .right),
        ]
        for (pos, dir, newPos, newDir) in tests {
            let (p, d) = onCube(pos: pos, dir: dir, map: map)
            assert((newPos, newDir) == (p, d))
        }
    }
    
    public func part02() -> String {
        let (map, moves) = parse()
        var visualMoves = [Pos: Dir]()
        var pos = initialPos(map: map)
        var dir: Dir = .right
//        testMap(map: map)
        for move in moves {
            switch move {
            case .right:
                dir = dir.rotRight
            case .left:
                dir = dir.rotLeft
            case .fwd(let steps):
                for _ in 0..<steps {
                    visualMoves[pos] = dir
                    var newPos = pos + dir.diff
                    var newDir = dir
                    if !(0 <= newPos.x && newPos.x < map[0].count && 0 <= newPos.y && newPos.y < map.count && map[newPos.y][newPos.x] != .no) {
                        (newPos, newDir) = onCube(pos: pos, dir: dir, map: map)
                    }
                    if map[newPos.y][newPos.x] == .wall {
                        break
                    }
                    pos = newPos
                    dir = newDir
                }
            }
        }
//        printMap(map, moves: visualMoves)
        return "\(1000 * (pos.y + 1) + 4 * (pos.x + 1) + dir.score)"
    }
}
