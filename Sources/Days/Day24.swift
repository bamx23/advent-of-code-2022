//
//  Day24.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 23/12/2022.
//

import Foundation
import Shared
import Collections

public struct Day24: Day {
    public static let number = 24

    let input: String
    
    public init(input: String) {
        self.input = input
    }

    enum Dir: CaseIterable {
        case up
        case right
        case down
        case left

        var diff: Pos {
            switch self {
            case .up:
                return .init(x: 0, y: -1)
            case .right:
                return .init(x: 1, y: 0)
            case .down:
                return .init(x: 0, y: 1)
            case .left:
                return .init(x: -1, y: 0)
            }
        }
    }

    typealias Map = [[[Dir]]]
    typealias SimpleMap = [[Bool]]

    func parse() -> Map {
        input
            .split(separator: "\n")
            .map { line in
                line.map { ch in
                    switch ch {
                    case "#", ".":
                        return []
                    case ">":
                        return [.right]
                    case "^":
                        return [.up]
                    case "<":
                        return [.left]
                    case "v":
                        return [.down]
                    default:
                        fatalError()
                    }
                }
            }
    }

    func allMaps(initial map: Map) -> [SimpleMap]
    {
        var curMap = map
        var result = [SimpleMap]()
        let (h, w) = (curMap.count, curMap[0].count)

        func simplify() -> SimpleMap {
            var result = curMap
                .enumerated()
                .map { (y, row) -> [Bool] in
                    row
                        .enumerated()
                        .map { (x, bzs) -> Bool in
                            x != 0 && y != 0 && x != w - 1 && y != h - 1 && bzs.isEmpty
                        }
                }
            result[0][1] = true
            result[h-1][w-2] = true
            return result
        }

        repeat {
            result.append(simplify())
            var nextMap = curMap
            for y in 1..<(h-1) {
                for x in 1..<(w-1) {
                    for bz in curMap[y][x] {
                        var (nx, ny) = (x + bz.diff.x, y + bz.diff.y)
                        if nx == 0 { nx = w - 2 }
                        if nx == w - 1 { nx = 1 }
                        if ny == 0 { ny = h - 2 }
                        if ny == h - 1 { ny = 1 }
                        nextMap[y][x].removeFirst()
                        nextMap[ny][nx].append(bz)
                    }
                }
            }
            curMap = nextMap
        } while (curMap != map)
        return result
    }

    struct State: Hashable, Comparable {
        var pos: Pos
        var mapIdx: Int

        var steps: Int
        var target: Pos

        var id: UUID
        var prevId: UUID?

        var priority: Int {
            let diff = target - pos
            return steps + abs(diff.x) + abs(diff.y)
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(pos)
            hasher.combine(mapIdx)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.mapIdx == rhs.mapIdx && lhs.pos == rhs.pos
        }

        static func < (lhs: Day24.State, rhs: Day24.State) -> Bool {
            lhs.priority < rhs.priority
        }
    }

    func printMap(map: SimpleMap, state: State) {
        var result = "S: \(state.steps)\n"
        let (h, w) = (map.count, map[0].count)
        for y in 0..<h {
            for x in 0..<w {
                var ch = map[y][x] ? "." : "*"
                if x == 0 || y == 0 || x == w - 1 || y == h - 1 {
                    ch = "#"
                }
                if x == 1 && y == 0 || x == w - 2 && y == h - 1 {
                    ch = "."
                }
                if state.pos == .init(x: x, y: y) {
                    ch = "@"
                }
                result += ch
            }
            result += "\n"
        }
        print(result)
    }

    func findWay(sMaps: [SimpleMap], initialState: State) -> [State] {
        var heap = Heap<State>()
        heap.insert(initialState)

        var visited = Set<State>()
        visited.insert(initialState)

        while var state = heap.popMin() {
            if state.pos == state.target {
                var states = [State]()
                var c: State? = state
                while let cc = c {
                    states.append(cc)
                    c = visited.first(where: { $0.id == cc.prevId })
                }
                states.reverse()
                return states
            }

            let nextMapIdx = (state.mapIdx + 1) % sMaps.count
            let sMap = sMaps[nextMapIdx]
            let pos = state.pos
            state.prevId = state.id
            state.id = .init()
            state.steps += 1
            state.mapIdx = nextMapIdx

            // wait
            if sMap[pos.y][pos.x] {
                if visited.contains(state) == false {
                    heap.insert(state)
                    visited.insert(state)
                }
            }

            for dir in Dir.allCases {
                let newPos = pos + dir.diff
                guard newPos.y >= 0 && newPos.y < sMap.count else { continue }
                guard sMap[newPos.y][newPos.x] else { continue }
                state.pos = newPos
                if visited.contains(state) == false {
                    heap.insert(state)
                    visited.insert(state)
                }
            }
        }
        fatalError()
    }
    
    public func part01() -> String {
        let map = parse()
        let (h, w) = (map.count, map[0].count)
        let sMaps = allMaps(initial: map)

        let path = findWay(sMaps: sMaps, initialState: .init(
            pos: .init(x: 1, y: 0),
            mapIdx: 0,
            steps: 0,
            target: .init(x: w-2, y: h-1),
            id: .init(),
            prevId: nil
        ))
        return "\(path.last!.steps)"
    }
    
    public func part02() -> String {
        let map = parse()
        let (h, w) = (map.count, map[0].count)
        let sMaps = allMaps(initial: map)

        let firstPath = findWay(sMaps: sMaps, initialState: .init(
            pos: .init(x: 1, y: 0),
            mapIdx: 0,
            steps: 0,
            target: .init(x: w-2, y: h-1),
            id: .init(),
            prevId: nil
        ))
        let secondPath = findWay(sMaps: sMaps, initialState: .init(
            pos: .init(x: w-2, y: h-1),
            mapIdx: firstPath.last!.mapIdx,
            steps: firstPath.last!.steps,
            target: .init(x: 1, y: 0),
            id: .init(),
            prevId: firstPath.last!.id
        ))
        let thirdPath = findWay(sMaps: sMaps, initialState: .init(
            pos: .init(x: 1, y: 0),
            mapIdx: secondPath.last!.mapIdx,
            steps: secondPath.last!.steps,
            target: .init(x: w-2, y: h-1),
            id: .init(),
            prevId: secondPath.last!.id
        ))
        return "\(thirdPath.last!.steps)"
    }
}
