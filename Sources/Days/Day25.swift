//
//  Day25.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 24/12/2022.
//

import Foundation
import Shared

public struct Day25: Day {
    static public let number = 25

    let input: String

    public init(input: String) {
        self.input = input
    }

    struct SNAFU {
        private static let powers: [Int] = (0...20).map { Int(pow(5, Double($0))) }

        private var digits: [Int]

        init(_ val: some Collection<Character>) {
            digits = val.map {
                switch $0 {
                case "0", "1", "2":
                    return $0.wholeNumberValue!
                case "-":
                    return -1
                case "=":
                    return -2
                default:
                    fatalError()
                }
            }
        }

        init(int val: Int) {
            guard val > 0 else { fatalError() }

            var digs = [0]
            var val = val
            var idx = Self.powers.firstIndex(where: { $0 > val })! - 1
            while val != 0 {
                digs.append(val / Self.powers[idx])
                val = val % Self.powers[idx]
                idx -= 1
            }
            digs.append(contentsOf: [Int](repeating: 0, count: idx + 1))
            for i in (1..<digs.count).reversed() {
                while digs[i] >= 3 {
                    digs[i - 1] += 1
                    digs[i] -= 5
                }
            }

            digits = Array(digs.drop(while: { $0 == 0 }))
        }

        var toInt: Int {
            digits.reduce(0, { $0 * 5 + $1 })
        }

        var toStr: String {
            digits
                .map { d -> String in
                    switch d {
                    case 0, 1, 2:
                        return "\(d)"
                    case -1:
                        return "-"
                    case -2:
                        return "="
                    default:
                        fatalError()
                    }
                }
                .joined()
        }
    }

    func parse() -> [SNAFU] {
        input.split(separator: "\n").map(SNAFU.init)
    }

    public func part01() -> String {
        let nums = parse()
        let sum = nums.map(\.toInt).reduce(0, +)
        return "\(SNAFU(int: sum).toStr)"
    }

    public func part02() -> String {
        return "Merry Xmas!"
    }
}
