//
//  Day04.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day04: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [(ClosedRange<Int>, ClosedRange<Int>)] {
        input
            .split(separator: "\n")
            .map { line in
                let pair = line
                    .split(separator: ",")
                    .map { s in
                        s.split(separator: "-")
                            .map { Int($0)! }
                    }
                    .map { a in ClosedRange(uncheckedBounds: (a[0], a[1])) }
                return (pair[0], pair[1])
            }
    }
    
    public func part01() -> String {
        let jobs = parse()
        let number = jobs
            .filter { (a, b) in
                (a.contains(b.lowerBound) && a.contains(b.upperBound))
                ||
                (b.contains(a.lowerBound) && b.contains(a.upperBound))
            }
            .count
        return "\(number)"
    }
    
    public func part02() -> String {
        let jobs = parse()
        let number = jobs
            .filter { (a, b) in
                a.contains(b.lowerBound) || a.contains(b.upperBound)
                ||
                b.contains(a.lowerBound) || b.contains(a.upperBound)
            }
            .count
        return "\(number)"
    }
}
