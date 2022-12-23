//
//  Day12.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day12: Day {
    static public let number = 12

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [[Int]] {
        input
            .split(separator: "\n")
            .map { line in
                line.map { ch in
                    switch ch {
                    case "S":
                        return -1
                    case "E":
                        return -2
                    default:
                        return Int(ch.asciiValue!) - Int("a".first!.asciiValue!)
                    }
                }
            }
    }
    
    typealias Pos = (x: Int, y: Int)
    
    func find(_ val: Int, map: [[Int]]) -> Pos {
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == val {
                    return (x, y)
                }
            }
        }
        fatalError()
    }
    
    func pathFind(map: [[Int]], start: Pos, end: Pos) -> Int {
        var queue: [Pos?] = [start, nil]
        let (w, h) = (map.first!.count, map.count)
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: w), count: h)
        visited[start.y][start.x] = true
        var len = 1
        while true {
            guard let pos = queue.removeFirst() else {
                if queue.isEmpty { break }
                len += 1
                queue.append(nil)
                continue
            }
            let posV = map[pos.y][pos.x]
            for dir in [(0, 1), (0, -1), (1, 0), (-1, 0)] {
                let next: Pos = (pos.x + dir.0, pos.y + dir.1)
                if 0 <= next.x && next.x < w && 0 <= next.y && next.y < h && visited[next.y][next.x] == false && map[next.y][next.x] <= posV + 1 {
                    queue.append(next)
                    visited[next.y][next.x] = true
                    if next.x == end.x && next.y == end.y {
                        return len
                    }
                }
            }
        }
        return Int.max
    }
    
    public func part01() -> String {
        var map = parse()
        let (start, end) = (find(-1, map: map), find(-2, map: map))
        map[start.y][start.x] = 0
        map[end.y][end.x] = 25
        return "\(pathFind(map: map, start: start, end: end))"
    }
    
    public func part02() -> String {
        var map = parse()
        let (start, end) = (find(-1, map: map), find(-2, map: map))
        map[start.y][start.x] = 0
        map[end.y][end.x] = 25
        var minLen = Int.max
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == 0 {
                    minLen = min(minLen, pathFind(map: map, start: (x, y), end: end))
                }
            }
        }
        return "\(minLen)"
    }
}
