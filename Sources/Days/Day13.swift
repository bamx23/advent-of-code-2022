//
//  Day13.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day13: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    enum Node {
        case val(Int)
        case list([Node])
        
        func comp(_ other: Node) -> Int {
            switch (self, other) {
            case (.val(let lhs), .val(let rhs)):
                return lhs - rhs
            case (.list(let lhs), .list(let rhs)):
                for idx in 0..<min(lhs.count, rhs.count) {
                    let r = lhs[idx].comp(rhs[idx])
                    if r != 0 {
                        return r
                    }
                }
                return lhs.count - rhs.count
            case (.val(let lhs), .list(let rhs)):
                return Node.list([.val(lhs)]).comp(.list(rhs))
            case (.list(let lhs), .val(let rhs)):
                return Node.list(lhs).comp(.list([.val(rhs)]))
            }
        }
    }
    
    static func parseNode(line: Substring) -> Node {
        if line.hasPrefix("[") == false {
            return .val(Int(line)!)
        }
        var stack = [[Node]]([[]])
        var num: Int?
        for ch in line {
            switch ch {
            case "0"..."9":
                let val = ch.wholeNumberValue!
                if let x = num {
                    num = x * 10 + val
                } else {
                    num = val
                }
            case ",":
                if let x = num {
                    stack[stack.count - 1].append(.val(x))
                    num = nil
                }
            case "[":
                stack.append([])
            case "]":
                if let x = num {
                    stack[stack.count - 1].append(.val(x))
                    num = nil
                }
                stack[stack.count - 2].append(.list(stack.last!))
                stack.removeLast()
            default:
                fatalError()
            }
        }
        return stack.first!.first!
    }
    
    func parse() -> [(Node, Node)] {
        let nodes = input
            .split(separator: "\n")
            .map(Self.parseNode(line:))
        return (0..<(nodes.count / 2))
            .map { idx in (nodes[idx * 2], nodes[idx * 2 + 1])}
    }
    
    public func part01() {
        let pairs = parse()
        print(pairs
                .map { (a, b) in a.comp(b) }
                .enumerated()
                .filter { (_, v) in v <= 0 }
                .map { $0.offset + 1 }
                .reduce(0, +)
        )
    }
    
    public func part02() {
        var nodes = parse().flatMap { (a,b) in [a,b] }
        let (n1, n2) = (
            Node.list([.list([.val(2)])]),
            Node.list([.list([.val(6)])])
        )
        nodes.append(contentsOf: [n1, n2])
        nodes.sort(by: { (a,b) in a.comp(b) < 0 })
        let p1 = nodes.firstIndex(where: { $0.comp(n1) == 0 })! + 1
        let p2 = nodes.firstIndex(where: { $0.comp(n2) == 0 })! + 1
        print(p1 * p2)
    }
}
