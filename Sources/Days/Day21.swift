//
//  Day21.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 20/12/2022.
//

import Foundation
import Shared

public struct Day21: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    enum Op {
        case sum
        case sub
        case mul
        case div
        case eq
        
        func calc(_ lhs: Int, _ rhs: Int) -> Int {
            switch self {
            case .sum:
                return lhs + rhs
            case .sub:
                return lhs - rhs
            case .mul:
                return lhs * rhs
            case .div:
                return lhs / rhs
            case .eq:
                return lhs == rhs ? 1 : 0
            }
        }
    }
    
    enum Action {
        case val(Int)
        case op(Op, String, String)
    }
    
    func parse() -> [String: Action] {
        .init(
            uniqueKeysWithValues: input
                .split(separator: "\n")
                .map { line -> (String, Action) in
                    let pair = line.split(separator: ":")
                    let name = String(pair[0])
                    let aParts = String(pair[1])
                        .trimmingCharacters(in: .whitespaces)
                        .split(separator: " ")
                        .map { String($0) }
                    let action: Action
                    if aParts.count == 1 {
                        action = .val(Int(aParts[0])!)
                    } else {
                        let op: Op
                        switch aParts[1] {
                        case "+":
                            op = .sum
                        case "-":
                            op = .sub
                        case "*":
                            op = .mul
                        case "/":
                            op = .div
                        default:
                            fatalError()
                        }
                        action = .op(op, aParts[0], aParts[2])
                    }
                    return (name, action)
                }
        )
    }
    
    func calc(name: String, _ monkeys: inout [String: Action]) -> Int {
        switch monkeys[name]! {
        case .val(let val):
            return val
        case .op(let op, let lhs, let rhs):
            let result = op.calc(calc(name: lhs, &monkeys), calc(name: rhs, &monkeys))
            monkeys[name] = .val(result)
            return result
        }
    }
    
    func findAndMark(target: String, cur: String, monkeys: [String: Action], path: inout Set<String>) -> Bool {
        guard cur != target else {
            return true
        }
        
        switch monkeys[cur]! {
        case .val:
            return false
        case .op(_, let lhs, let rhs):
            let result = findAndMark(target: target, cur: lhs, monkeys: monkeys, path: &path)
            || findAndMark(target: target, cur: rhs, monkeys: monkeys, path: &path)
            if result {
                path.insert(cur)
            }
            return result
        }
    }
    
    func preCalc(name: String, _ monkeys: inout [String: Action], path: Set<String>) -> Int {
        switch monkeys[name]! {
        case .val(let val):
            return val
        case .op(let op, let lhs, let rhs):
            let result = op.calc(preCalc(name: lhs, &monkeys, path: path), preCalc(name: rhs, &monkeys, path: path))
            if path.contains(name) == false {
                monkeys[name] = .val(result)
            }
            return result
        }
    }
    
    public func part01() -> String {
        var monkeys = parse()
        return "\(calc(name: "root", &monkeys))"
    }
    
    public func part02() -> String {
        let me = "humn"
        let root = "root"
        var monkeys = parse()
        if case .op(_, let lhs, let rhs) = monkeys[root] {
            monkeys[root] = .op(.eq, lhs, rhs)
        }
        var path = Set([me])
        _ = findAndMark(target: me, cur: root, monkeys: monkeys, path: &path)
        _ = preCalc(name: root, &monkeys, path: path)
        
        var name = root
        var expected = 1
        while name != me {
            guard case .op(let op, let lhs, let rhs) = monkeys[name] else { fatalError() }
            let (next, valName) = path.contains(lhs) ? (lhs, rhs) : (rhs, lhs)
            guard case .val(let val) = monkeys[valName] else { fatalError() }
            
            switch op {
            case .eq:
                guard expected == 1 else { fatalError() }
                expected = val
            case .sum:
                expected -= val
            case .sub:
                expected = next == lhs ? (expected + val) : (val - expected)
            case .mul:
                expected /= val
            case .div:
                expected = next == lhs ? (expected * val) : (val / expected)
            }
            
            name = next
        }
        return "\(expected)"
    }
}
