//
//  Day06.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day06: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func findSignal(_ line: String, len: Int) -> Int {
        let line = Array(line)
        var cur = " " + line.prefix(len - 1)
        var idx = len - 1
        while idx < line.count {
            cur = cur.dropFirst() + String(line[idx])
            idx += 1
            if Set(cur).count == cur.count {
                return idx
            }
        }
        return 0
    }
    
    public func part01() -> String {
        return "\(findSignal(input, len: 4))"
    }
    
    public func part02() -> String {
        return "\(findSignal(input, len: 14))"
    }
}
