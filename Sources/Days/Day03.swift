//
//  Day03.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day03: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [([Character], [Character])] {
        input
            .split(separator: "\n")
            .map { line in
                let chars = Array(line)
                let half = chars.count / 2
                return (Array(chars.prefix(half)), Array(chars.suffix(half)))
            }
    }
    
    func priority(_ ch: Character) -> Int {
        switch ch {
        case "a"..."z":
            return Int(ch.asciiValue! - "a".first!.asciiValue!) + 1
        case "A"..."Z":
            return Int(ch.asciiValue! - "A".first!.asciiValue!) + 27
        default:
            fatalError()
        }
    }
    
    public func part01() -> String {
        let rsks = parse()
        let score = rsks
            .map { (a, b) in Set(a).intersection(Set(b)).first! }
            .map(priority)
            .reduce(0, +)
        return "\(score)"
    }
    
    public func part02() -> String {
        let rsks = parse()
            .map { $0.0 + $0.1 }
            .map(Set.init)
        let groups = (0..<(rsks.count / 3))
            .map { idx -> [Set<Character>] in [rsks[idx * 3], rsks[idx * 3 + 1], rsks[idx * 3 + 2]] }
        let score = groups
            .map { grp -> Character in
                grp[0]
                    .intersection(grp[1])
                    .intersection(grp[2])
                    .first!
            }
            .map(priority)
            .reduce(0, +)
        return "\(score)"
    }
}
