//
//  Day18.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 17/12/2022.
//

import Foundation
import Shared

public struct Day18: Day {
    static public let number = 18

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [Pos3] {
        input
            .split(separator: "\n")
            .map { line in
                let parts = line
                    .split(separator: ",")
                    .map { Int($0)! }
                return .init(x: parts[0], y: parts[1], z: parts[2])
            }
    }
    
    enum SideKind: CaseIterable, Hashable {
        case right
        case rear
        case top
        case left
        case front
        case down
        
        var dir: Pos3 {
            switch self {
            case .right:
                return .init(x: 1, y: 0, z: 0)
            case .rear:
                return .init(x: 0, y: 1, z: 0)
            case .top:
                return .init(x: 0, y: 0, z: 1)
            case .left:
                return .init(x: -1, y: 0, z: 0)
            case .front:
                return .init(x: 0, y: -1, z: 0)
            case .down:
                return .init(x: 0, y: 0, z: -1)
            }
        }
        
        var opposite: Self {
            switch self {
            case .right:
                return .left
            case .rear:
                return .front
            case .top:
                return .down
            case .left:
                return .right
            case .front:
                return .rear
            case .down:
                return .top
            }
        }
    }
    
    struct Side: Hashable {
        var pos: Pos3
        var kind: SideKind
        
        func drops() -> [Pos3] {
            [pos, pos + kind.dir]
        }
    }
    
    func normalize(side: Side) -> Side {
        switch side.kind {
        case .right, .rear, .top:
            return side
        case .left, .front, .down:
            return .init(pos: side.pos + side.kind.dir, kind: side.kind.opposite)
        }
    }
    
    func uncoveredSides(_ drops: some Collection<Pos3>) -> [Side] {
        let sides = drops
            .flatMap { d in
                SideKind.allCases.map { Side(pos: d, kind: $0) }
            }
            .map(normalize(side:))
        return Dictionary(grouping: sides, by: { $0 })
            .filter { $0.value.count == 1 }
            .map(\.key)
    }
    
    public func part01() -> String {
        let drops = parse()
        return "\(uncoveredSides(drops).count)"
    }
    
    public func part02() -> String {
        let drops = Set(parse())
        let sides = uncoveredSides(drops)
        var externalSides = Set(sides)
        
        let minPos: Pos3 = .init(x: drops.map(\.x).min()!, y: drops.map(\.y).min()!, z: drops.map(\.z).min()!)
        let maxPos: Pos3 = .init(x: drops.map(\.x).max()!, y: drops.map(\.y).max()!, z: drops.map(\.z).max()!)
        let dirs = SideKind.allCases.map(\.dir)
        
        for side in sides {
            if externalSides.contains(side) == false { continue }
            let externalDrop = side.drops().first(where: { drops.contains($0) == false })!
            
            var stack = [externalDrop]
            var visited = Set([externalDrop])
            var isExternal = false
            while stack.isEmpty == false {
                let drop = stack.removeLast()
                for dir in dirs {
                    let next = drop + dir
                    guard drops.contains(next) == false else { continue }
                    guard visited.contains(next) == false else { continue }
                    guard minPos.x <= next.x && next.x <= maxPos.x
                            && minPos.y <= next.y && next.y <= maxPos.y
                            && minPos.z <= next.z && next.z <= maxPos.z else {
                        // We've got to open air
                        stack.removeAll()
                        isExternal = true
                        break
                    }
                    
                    visited.insert(next)
                    stack.append(next)
                }
            }
            
            if isExternal == false {
                let internalSides = uncoveredSides(visited)
                externalSides.subtract(internalSides)
            }
        }
        
        return "\(externalSides.count)"
    }
}
