//
//  Day06.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

struct Day06: Day {
    var input: String
    
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
    
    func part01() {
        print(findSignal(input, len: 4))
    }
    
    func part02() {
        print(findSignal(input, len: 14))
    }
}
