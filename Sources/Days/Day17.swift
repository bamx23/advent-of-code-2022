//
//  Day17.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 17/12/2022.
//

import Foundation
import Shared

public struct Day17: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    typealias Figure = [Pos]
    
    enum Wind {
        case left
        case right
    }
    
    let width = 7
    let spawnPoint: Pos = .init(x: 2, y: 4)
    let figures: [Figure] = [
        /* - */ [.init(x: 0, y: 0), .init(x: 1, y: 0), .init(x: 2, y: 0), .init(x: 3, y: 0)],
        /* + */ [.init(x: 1, y: 0), .init(x: 0, y: 1), .init(x: 1, y: 1), .init(x: 2, y: 1), .init(x: 1, y: 2)],
        /* ⅃ */ [.init(x: 0, y: 0), .init(x: 1, y: 0), .init(x: 2, y: 0), .init(x: 2, y: 1), .init(x: 2, y: 2)],
        /* | */ [.init(x: 0, y: 0), .init(x: 0, y: 1), .init(x: 0, y: 2), .init(x: 0, y: 3)],
        /* ■ */ [.init(x: 0, y: 0), .init(x: 0, y: 1), .init(x: 1, y: 0), .init(x: 1, y: 1)],
    ]
    
    func parse() -> [Wind] {
        input.dropLast().map {
            switch $0 {
            case ">":
                return .right
            case "<":
                return .left
            default:
                fatalError()
            }
        }
    }
    
    func move(figure: Figure, pos: Pos, map: [[Bool]], direction: Pos, shift: Int = 0) -> Pos? {
        let newPos = pos + direction
        for part in figure {
            let p = part + newPos
            guard 0 <= p.x && p.x < width && 0 <= p.y else { return nil }
            guard p.y - shift < map.count else { fatalError() }
            guard map[p.y - shift][p.x] == false else { return nil }
        }
        return newPos
    }
    
    func apply(figure: Figure, pos: Pos, map: inout [[Bool]], shift: Int = 0) {
        for part in figure {
            let p = part + pos
            map[p.y - shift][p.x] = true
        }
    }
    
    func printMap(_ map: [[Bool]], figure: Figure, pos: Pos, shift: Int = 0) {
        var figureMap: [[Bool]] = .init(repeating: .init(repeating: false, count: width), count: map.count)
        apply(figure: figure, pos: pos, map: &figureMap, shift: shift)
        for y in (0..<map.count).reversed() {
            let line = (0..<width)
                .map { x -> Character in map[y][x] ? "#" : (figureMap[y][x] ? "@" : ".") }
            print("|\(String(line))|")
        }
        if (shift == 0) {
            print("+-------+")
        }
        print("")
    }
    
    public func part01() {
        let winds = parse()
        
        var topHeight = -1
        var windIndex = 0
        var figureIndex = 0
        var map: [[Bool]] = .init(repeating: .init(repeating: false, count: width),
                                  count: spawnPoint.y + figures.first!.height)
        
        for _ in 0..<2022 {
            let figure = figures[figureIndex]
            figureIndex = (figureIndex + 1) % figures.count
            
            var figurePos: Pos = .init(x: spawnPoint.x, y: topHeight + spawnPoint.y)
            let pendingHeight = figurePos.y + figure.height - (map.count - 1)
            if pendingHeight > 0 {
                map.append(contentsOf: Array(repeating: .init(repeating: false, count: width), count: pendingHeight))
            }
            
            while true {
                let wind = winds[windIndex]
                windIndex = (windIndex + 1) % winds.count
                
                figurePos = move(figure: figure, pos: figurePos, map: map, direction: wind.dir) ?? figurePos
                
                if let downPos = move(figure: figure, pos: figurePos, map: map, direction: .init(x: 0, y: -1)) {
                    figurePos = downPos
                } else {
                    break
                }
            }
            apply(figure: figure, pos: figurePos, map: &map)
            topHeight = max(topHeight, figurePos.y + figure.height)
        }
        print(topHeight + 1)
    }
    
    struct State: Hashable {
        static let memHeight = 100
        
        var windIndex: Int
        var figureIndex: Int
        var topField: [Int]
        
        init(windIndex: Int, figureIndex: Int, map: [[Bool]]) {
            self.windIndex = windIndex
            self.figureIndex = figureIndex
            self.topField = map
                .suffix(Self.memHeight)
                .map { line in line.reduce(0, { ($0 << 1) | ($1 ? 1 : 0) }) }
        }
    }
    
    public func part02() {
        let winds = parse()
        
        var topHeight = -1
        var windIndex = 0
        var figureIndex = 0
        var shift = 0
        var map: [[Bool]] = .init(repeating: .init(repeating: false, count: width),
                                  count: spawnPoint.y + figures.first!.height)
        var cache: [State: (Int, Int)] = [:]
        var skipCache = false
        
        var day = 0
        let span = 1000000000000
        while day < span {
            let figure = figures[figureIndex]
            figureIndex = (figureIndex + 1) % figures.count
            
            var figurePos: Pos = .init(x: spawnPoint.x, y: topHeight + spawnPoint.y)
            let pendingHeight = figurePos.y + figure.height - (map.count + shift - 1)
            if pendingHeight > 0 {
                map.append(contentsOf: Array(repeating: .init(repeating: false, count: width), count: pendingHeight))
            }
            let cutHeight = map.count - 100000
            if cutHeight > 1000 {
                shift += cutHeight
                map.removeFirst(cutHeight)
            }
            
            while true {
                let wind = winds[windIndex]
                windIndex = (windIndex + 1) % winds.count
                
                figurePos = move(figure: figure, pos: figurePos, map: map, direction: wind.dir, shift: shift) ?? figurePos
                
                if let downPos = move(figure: figure, pos: figurePos, map: map, direction: .init(x: 0, y: -1), shift: shift) {
                    figurePos = downPos
                } else {
                    break
                }
            }
            apply(figure: figure, pos: figurePos, map: &map, shift: shift)
            topHeight = max(topHeight, figurePos.y + figure.height)
            
            if !skipCache {
                let state: State = .init(windIndex: windIndex, figureIndex: figureIndex, map: map)
                if let (oldDay, oldHeight) = cache[state] {
                    let daysDiff = day - oldDay
                    let repeats = (span - day) / daysDiff
                    day += (repeats * daysDiff) + 1
                    let heightDiff = repeats * (topHeight - oldHeight)
                    topHeight += heightDiff
                    shift += heightDiff
                    skipCache = true
                    continue
                }
                cache[state] = (day, topHeight)
            }
            day += 1
        }
        print(topHeight + 1)
    }
}

extension Day17.Figure {
    var height: Int {
        map(\.y).max() ?? 0
    }
    var width: Int {
        map(\.x).max() ?? 0
    }
}

extension Day17.Wind {
    var dir: Pos {
        switch self {
        case .left:
            return .init(x: -1, y: 0)
        case .right:
            return .init(x: 1, y: 0)
        }
    }
}
