//
//  Day08.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day08: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [[Int]] {
        input
            .split(separator: "\n")
            .map { line in
                line.map { $0.wholeNumberValue! }
            }
    }
    
    func visibilityLevels(_ map: [[Int]]) -> [[Int]] {
        let h = map.count
        let w = map.first!.count
        var visibility = [[Int]](repeating: [Int](repeating: 0, count: w), count: h)
        var maxBefore = 0
        
        for y in 0..<h {
            visibility[y][0] += 1
            maxBefore = map[y][0]
            for x in 1..<w {
                if map[y][x] > maxBefore {
                    visibility[y][x] += 1
                    maxBefore = map[y][x]
                    if (maxBefore == 9) { break }
                }
            }
            visibility[y][w - 1] += 1
            maxBefore = map[y][w - 1]
            for x in (0..<(w - 1)).reversed() {
                if map[y][x] > maxBefore {
                    visibility[y][x] += 1
                    maxBefore = map[y][x]
                    if (maxBefore == 9) { break }
                }
            }
        }
        for x in 0..<w {
            visibility[0][x] += 1
            maxBefore = map[0][x]
            for y in 1..<h {
                if map[y][x] > maxBefore {
                    visibility[y][x] += 1
                    maxBefore = map[y][x]
                    if (maxBefore == 9) { break }
                }
            }
            visibility[h - 1][x] += 1
            maxBefore = map[h - 1][x]
            for y in (0..<(h - 1)).reversed() {
                if map[y][x] > maxBefore {
                    visibility[y][x] += 1
                    maxBefore = map[y][x]
                    if (maxBefore == 9) { break }
                }
            }
        }

        return visibility
    }
    
    func scores(_ map: [[Int]]) -> [[Int]] {
        let h = map.count
        let w = map.first!.count
        var scores = [[Int]](repeating: [Int](repeating: 0, count: w), count: h)
        
        for y in 1..<(h - 1) {
            for x in 1..<(w - 1) {
//                    print("\(y) \(x) \(map[y][x])")
                var score = 1
                for (dx, dy) in [(0, -1), (-1, 0), (1, 0), (0, 1)] {
                    var (nx, ny) = (x + dx, y + dy)
                    var dirScore = 0
                    while 0 <= nx && nx < w && 0 <= ny && ny < h {
                        if map[ny][nx] >= map[y][x] {
                            dirScore += 1
                            break
                        }
                        (nx, ny) = (nx + dx, ny + dy)
                        dirScore += 1
                    }
//                        print(dirScore)
                    score *= dirScore
                }
//                    print(score)
                scores[y][x] = score
            }
        }

        return scores
    }
    
    func printMap(_ map: [[Int]]) {
        for l in map {
            print(l.map { "\($0)" }.joined())
        }
    }
    
    public func part01() -> String {
        let map = parse()
        let visibility = visibilityLevels(map)
//        printMap(visibility)
        let count = visibility
            .map { l in l.filter { $0 > 0 }.count }
            .reduce(0, +)
        return "\(count)"
    }
    
    public func part02() -> String {
        let map = parse()
        let scores = scores(map)
//        printMap(scores)
        let best = scores
            .map { $0.max()! }
            .max()!
        return "\(best)"
    }
}
