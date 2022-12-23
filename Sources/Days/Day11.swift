//
//  Day11.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day11: Day {
    static public let number = 11

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    class Monkey {
        var items: [Int]
        let operation: (Int) -> Int
        let divider: Int
        let sendIfTrue: Int
        let sendIfFalse: Int
        init(_ i: [Int], op: @escaping (Int) -> Int, d: Int, t: Int, f: Int) {
            items = i
            operation = op
            divider = d
            sendIfTrue = t
            sendIfFalse = f
        }
    }
    
    func parse() -> [Monkey] {
        let lines = input
            .split(separator: "\n")
        return (0..<((lines.count)/6))
            .map { idx in
                let sIdx = idx * 6
                let items = lines[sIdx + 1]
                    .split(separator: " ")
                    .dropFirst(2)
                    .map { $0.hasSuffix(",") ? $0.dropLast() : $0 }
                    .map { Int($0)! }
                let operation: (Int)->Int
                let ops = Array(lines[sIdx + 2]
                    .split(separator: " ")
                    .suffix(2))
                let (op1, op2) = (ops[0], ops[1])
                switch (op1, op2) {
                case ("+", "old"):
                    operation = { $0 + $0 }
                case ("*", "old"):
                    operation = { $0 * $0 }
                case ("+", let val):
                    operation = { $0 + Int(val)! }
                case ("*", let val):
                    operation = { $0 * Int(val)! }
                default:
                    fatalError()
                }
                let div = Int(lines[sIdx + 3]
                    .split(separator: " ")
                    .last!)!
                let sendT = Int(lines[sIdx + 4]
                                .split(separator: " ")
                                .last!)!
                let sendF = Int(lines[sIdx + 5]
                                .split(separator: " ")
                                .last!)!
                return .init(items, op: operation, d: div, t: sendT, f: sendF)
            }
    }
    
    public func part01() -> String {
        let mks = parse()
        var inspects = mks.map { _ in 0 }
        for _ in 0..<20 {
            for (idx, m) in mks.enumerated() {
                inspects[idx] += m.items.count
                for i in m.items {
                    let x = m.operation(i) / 3
                    if x.isMultiple(of: m.divider) {
                        mks[m.sendIfTrue].items.append(x)
                    } else {
                        mks[m.sendIfFalse].items.append(x)
                    }
                }
                m.items.removeAll()
            }
        }
        return "\(inspects.sorted().suffix(2).reduce(1, *))"
    }
    
    public func part02() -> String {
        let mks = parse()
        let div = mks.map(\.divider).reduce(1, *)
        var inspects = mks.map { _ in 0 }
        for _ in 0..<10000 {
            for (idx, m) in mks.enumerated() {
                inspects[idx] += m.items.count
                for i in m.items {
                    let x = m.operation(i) % div
                    if x.isMultiple(of: m.divider) {
                        mks[m.sendIfTrue].items.append(x)
                    } else {
                        mks[m.sendIfFalse].items.append(x)
                    }
                }
                m.items.removeAll()
            }
        }
        return "\(inspects.sorted().suffix(2).reduce(1, *))"
    }
}
