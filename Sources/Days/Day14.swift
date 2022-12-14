//
//  Day14.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day14: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    typealias Pos = (x: Int, y: Int)
    typealias Path = [Pos]
    
    enum Tile {
        case air
        case rock
        case sand
    }
    
    func parse() -> [Path] {
        input
            .split(separator: "\n")
            .map { line in
                line.split(separator: ">")
                    .map { $0.hasSuffix(" -") ? $0.dropLast(2) : $0 }
                    .map { $0.hasPrefix(" ") ? $0.dropFirst() : $0 }
                    .map { str -> Pos in
                        let pair = str.split(separator: ",")
                        return (x: Int(pair[0])!, y: Int(pair[1])!)
                    }
            }
    }
    
    public func part01() {
        let paths = parse()
        
        let minX = paths.map { $0.map(\.x).min()! }.min()!
        let maxX = paths.map { $0.map(\.x).max()! }.max()!
        let minY = paths.map { $0.map(\.y).min()! }.min()!
        let maxY = paths.map { $0.map(\.y).max()! }.max()!
        let (h, w) = (maxY - minY + 1, maxX - minX + 1)
        let gap = 50
        
        func mX(_ pos: Pos) -> Int { pos.x - minX + gap }
        func mY(_ pos: Pos) -> Int { pos.y - minY + gap }
        
        var map = [[Tile]](repeating: [Tile](repeating: .air, count: w + gap * 2), count: h + gap * 2)
        for path in paths {
            for (a, b) in zip(path.dropLast(), path.dropFirst()) {
                if a.x == b.x {
                    for y in min(a.y, b.y)...max(a.y, b.y) {
                        map[y - minY + gap][a.x - minX + gap] = .rock
                    }
                } else if a.y == b.y {
                    for x in min(a.x, b.x)...max(a.x, b.x) {
                        map[a.y - minY + gap][x - minX + gap] = .rock
                    }
                } else {
                    fatalError()
                }
            }
        }
        
        let sandStart: Pos = (500, 0)
        while true {
            var sand = sandStart
            var isInfinite = false
            while true {
                if sand.y > maxY {
                    isInfinite = true
                    break
                }
                if map[mY(sand) + 1][mX(sand)] == .air {
                    sand.y += 1
                } else if map[mY(sand) + 1][mX(sand) - 1] == .air {
                    sand.y += 1
                    sand.x -= 1
                } else if map[mY(sand) + 1][mX(sand) + 1] == .air {
                    sand.y += 1
                    sand.x += 1
                } else {
                    map[mY(sand)][mX(sand)] = .sand
                    break
                }
            }
            if isInfinite {
                break
            }
        }
        
        let count = map
            .map { line in line.filter { $0 == .sand }.count }
            .reduce(0, +)
        print(count)
    }
    
    public func part02() {
        let paths = parse()
        
        let minX = paths.map { $0.map(\.x).min()! }.min()!
        let maxX = paths.map { $0.map(\.x).max()! }.max()!
        let minY = paths.map { $0.map(\.y).min()! }.min()!
        let maxY = paths.map { $0.map(\.y).max()! }.max()!
        let (h, w) = (maxY - minY + 1, maxX - minX + 1)
        let gap = 200
        
        func mX(_ pos: Pos) -> Int { pos.x - minX + gap }
        func mY(_ pos: Pos) -> Int { pos.y - minY + gap }
        
        var map = [[Tile]](repeating: [Tile](repeating: .air, count: w + gap * 2), count: h + gap * 2)
        for path in paths {
            for (a, b) in zip(path.dropLast(), path.dropFirst()) {
                if a.x == b.x {
                    for y in min(a.y, b.y)...max(a.y, b.y) {
                        map[y - minY + gap][a.x - minX + gap] = .rock
                    }
                } else if a.y == b.y {
                    for x in min(a.x, b.x)...max(a.x, b.x) {
                        map[a.y - minY + gap][x - minX + gap] = .rock
                    }
                } else {
                    fatalError()
                }
            }
        }
        
        let sandStart: Pos = (500, 0)
        while true {
            var sand = sandStart
            if map[mY(sand)][mX(sand)] == .sand {
                break
            }
            while true {
                if sand.y == maxY + 1 {
                    map[mY(sand)][mX(sand)] = .sand
                    break
                }
                if map[mY(sand) + 1][mX(sand)] == .air {
                    sand.y += 1
                } else if map[mY(sand) + 1][mX(sand) - 1] == .air {
                    sand.y += 1
                    sand.x -= 1
                } else if map[mY(sand) + 1][mX(sand) + 1] == .air {
                    sand.y += 1
                    sand.x += 1
                } else {
                    map[mY(sand)][mX(sand)] = .sand
                    break
                }
            }
        }
        
        let count = map
            .map { line in line.filter { $0 == .sand }.count }
            .reduce(0, +)
        print(count)
    }
}
