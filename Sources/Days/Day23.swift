//
//  Day23.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 22/12/2022.
//

import Foundation
import Shared

public struct Day23: Day {
    static public let number = 23

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    typealias Map = Set<Pos>
    
    enum Dir {
        case N
        case E
        case S
        case W
        
        var diff: Pos {
            switch self {
            case .N:
                return .init(x: 0, y: -1)
            case .E:
                return .init(x: 1, y: 0)
            case .S:
                return .init(x: 0, y: 1)
            case .W:
                return .init(x: -1, y: 0)
            }
        }
        
        var lookDiffs: [Pos] {
            switch self {
            case .N:
                return [.init(x: -1, y: -1), .init(x: 0, y: -1), .init(x: 1, y: -1)]
            case .E:
                return [.init(x: 1, y: -1), .init(x: 1, y: 0), .init(x: 1, y: 1)]
            case .S:
                return [.init(x: -1, y: 1), .init(x: 0, y: 1), .init(x: 1, y: 1)]
            case .W:
                return [.init(x: -1, y: -1), .init(x: -1, y: 0), .init(x: -1, y: 1)]
            }
        }
    }
    
    func parse() -> Map {
        Set(
            input
                .split(separator: "\n")
                .enumerated()
                .flatMap { (y, line) in
                    line
                        .enumerated()
                        .filter { _, ch in ch == "#" }
                        .map { x, _ in Pos(x: x, y: y) }
                }
        )
    }
    
    @discardableResult
    func makeMove(map: inout Map, moves: inout [Dir]) -> Bool {
        var moved = false
        
        // target -> [src]
        var elfMoves = [Pos: [Pos]]()
        for pos in Array(map) {
            let targets = moves.filter { dir in
                for lDiff in dir.lookDiffs {
                    if map.contains(pos + lDiff) {
                        return false
                    }
                }
                return true
            }
            if targets.count == moves.count { continue }
            if let newPos = targets.first.map({ pos + $0.diff }) {
                elfMoves[newPos, default: []].append(pos)
            }
        }
        
        for (target, srcs) in elfMoves {
            if srcs.count == 1 {
                moved = true
                map.remove(srcs[0])
                map.insert(target)
            }
        }
        
        moves.append(moves.removeFirst())
        return moved
    }
    
    func mapSize(_ map: Map) -> (minX: Int, maxX: Int, minY: Int, maxY: Int) {
        (
            map.map(\.x).min()!, map.map(\.x).max()!,
            map.map(\.y).min()!, map.map(\.y).max()!
        )
    }
    
    func printMap(_ map: Map) {
        var result = ""
        let size = mapSize(map)
        for y in size.minY...size.maxY {
            for x in size.minX...size.maxX {
                result += map.contains(.init(x: x, y: y)) ? "#" : "."
            }
            result += "\n"
        }
        print(result)
    }
    
    public func part01() -> String {
        var map = parse()
        var moves: [Dir] = [.N, .S, .W, .E]
        for _ in 0..<10 {
            makeMove(map: &map, moves: &moves)
        }
        
        var emptyCount = 0
        let size = mapSize(map)
        for y in size.minY...size.maxY {
            for x in size.minX...size.maxX {
                if map.contains(.init(x: x, y: y)) == false {
                    emptyCount += 1
                }
            }
        }
        
        return "\(emptyCount)"
    }
    
    public func part02() -> String {
        var map = parse()
        var moved = true
        var moves: [Dir] = [.N, .S, .W, .E]
        var roundNum = 0
        while moved {
            roundNum += 1
            moved = makeMove(map: &map, moves: &moves)
        }
        return "\(roundNum)"
    }
}
