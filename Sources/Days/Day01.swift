//
//  Day01.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day01: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [[Int]] {
        input
            .split(separator: "\n", omittingEmptySubsequences: false)
            .reduce(into: [[]], { (partialResult, str) in
              if (str.isEmpty) {
                partialResult.append([])
              } else {
                partialResult[partialResult.count - 1].append(Int(str)!)
              }
            })
    }
    
    public func part01() {
        let elfs = parse()
        let max = elfs
            .map { $0.reduce(0, +) }
            .max()!
        print(max)
    }
    
    public func part02() {
        let elfs = parse()
        let max3 = elfs
            .map { $0.reduce(0, +) }
            .sorted()
            .suffix(3)
            .reduce(0, +)
        print(max3)
    }
}
