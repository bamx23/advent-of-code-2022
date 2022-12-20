//
//  Day20.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 19/12/2022.
//

import Foundation
import Shared

public struct Day20: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [Int] {
        input
            .split(separator: "\n")
            .map { Int($0)! }
    }
    
    class Node {
        let val: Int
        var prev: Node!
        var next: Node!
        
        init(val: Int) {
            self.val = val
        }
    }
    
    func makeList(_ arr: [Int]) -> [Node] {
        let nodes = arr.map(Node.init)
        for idx in 1..<nodes.count {
            nodes[idx].prev = nodes[idx - 1]
            nodes[idx - 1].next = nodes[idx]
        }
        nodes.first!.prev = nodes.last!
        nodes.last!.next = nodes.first!
        return nodes
    }
    
    func moveFwd(_ node: Node) {
        let next = node.next!
        node.next = next.next
        next.next.prev = node
        
        next.prev = node.prev
        node.prev.next = next
        
        node.prev = next
        next.next = node
    }
    
    func moveBck(_ node: Node) {
        moveFwd(node.prev)
    }
    
    func printSample(_ nodes: [Node], start: Int) {
        guard nodes.count < 100 else { return }
        var arr = [Int]()
        var node = nodes.first(where: { $0.val == start })!
        for _ in 0..<nodes.count {
            arr.append(node.val)
            node = node.next
        }
        print(arr)
    }
    
    public func part01() -> String {
        let data = parse()
        let nodes = makeList(data)
        for node in nodes {
            if node.val > 0 {
                for _ in 0..<node.val {
                    moveFwd(node)
                }
            } else if node.val < 0 {
                for _ in 0..<(-node.val) {
                    moveBck(node)
                }
            }
        }
        
//        printSample(nodes, start: 1)
        
        var node = nodes.first(where: { $0.val == 0 })!
        var nums = [Int]()
        for _ in 0..<3 {
            for _ in 0..<1000 {
                node = node.next
            }
            nums.append(node.val)
        }
        return "\(nums.reduce(0, +))"
    }
    
    public func part02() -> String {
        let key = 811589153
        let data = parse()
        let nodes = makeList(data.map { $0 * key })
        for _ in 0..<10 {
            for node in nodes {
                if node.val > 0 {
                    for _ in 0..<(node.val % (nodes.count - 1)) {
                        moveFwd(node)
                    }
                } else if node.val < 0 {
                    for _ in 0..<((-node.val) % (nodes.count - 1)) {
                        moveBck(node)
                    }
                }
            }
        }
        
//        printSample(nodes, start: 0)
        
        var node = nodes.first(where: { $0.val == 0 })!
        var nums = [Int]()
        for _ in 0..<3 {
            for _ in 0..<1000 {
                node = node.next
            }
            nums.append(node.val)
        }
        return "\(nums.reduce(0, +))"
    }
}
