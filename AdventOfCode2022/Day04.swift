//
//  Day04.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

struct Day04: Day {
    var input: String
    
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
    
    func part01() {
        let jobs = parse()
        let number = jobs
            .filter { (a, b) in
                (a.contains(b.lowerBound) && a.contains(b.upperBound))
                ||
                (b.contains(a.lowerBound) && b.contains(a.upperBound))
            }
            .count
        print(number)
    }
    
    func part02() {
        let jobs = parse()
        let number = jobs
            .filter { (a, b) in
                a.contains(b.lowerBound) || a.contains(b.upperBound)
                ||
                b.contains(a.lowerBound) || b.contains(a.upperBound)
            }
            .count
        print(number)
    }
}
