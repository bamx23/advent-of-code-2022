//
//  Day15.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day15: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    func parse() -> [(Pos, Pos)] {
        input
            .split(separator: "\n")
            .map { line in
                let pair = line
                    .split(separator: ":")
                    .map { p -> Pos in
                        let nums = p
                            .split(separator: " ")
                            .suffix(2)
                            .map { $0.dropFirst(2) }
                            .map { $0.hasSuffix(",") ? $0.dropLast() : $0 }
                            .map { Int($0)! }
                        return Pos(x: nums[0], y: nums[1])
                    }
                return (pair[0], pair[1])
            }
    }
    
    public func part01() -> String {
        let measures = parse()
        let y = measures.count <= 15 ? 10 : 2000000
        let ranges = measures
            .compactMap { (sensor, beacon) -> ClosedRange<Int>? in
                let dist = abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
                let yDist = abs(sensor.y - y)
                let xDist = dist - yDist
                guard xDist >= 0 else { return nil }
                return (sensor.x - xDist)...(sensor.x + xDist)
            }
            .sorted(by: { (a,b) in a.lowerBound < b.lowerBound })
        if ranges.isEmpty { return "" }
        
        var count = 0
        var x = Int.min
        for range in ranges {
            if range.upperBound < x { continue }
            if range.lowerBound > x {
                x = range.lowerBound
            }
            count += range.upperBound - x + 1
            x = range.upperBound + 1
        }
        
        for beacon in Set(measures.map(\.1)) {
            if beacon.y == y {
                count -= 1
            }
        }
        
        return "\(count)"
    }
    
    public func part02() -> String {
        let measures = parse()
        let len = measures.count <= 15 ? 20 : 4000000
        
        func isValid(x: Int, y: Int) -> String? {
            guard 0 <= x && x <= len && 0 <= y && y <= len else { return nil }
            for (sensor, beacon) in measures {
                let distEx = abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
                let distNew = abs(sensor.x - x) + abs(sensor.y - y)
                if distNew <= distEx {
                    return nil
                }
            }
            let freq = x * 4000000 + y
            print("x=\(x), y=\(y), freq=\(x * 4000000 + y)")
            return "\(freq)"
        }
        
        for (sensor, beacon) in measures {
            let dist = abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
            for k in 0...dist {
                if let r = isValid(x: sensor.x - dist - 1 + k, y: sensor.y - k) { return r }
            }
            for k in 0...dist {
                if let r = isValid(x: sensor.x + k, y: sensor.y - dist - 1 + k) { return r }
            }
            for k in 0...dist {
                if let r = isValid(x: sensor.x + dist + 1 - k, y: sensor.y + k) { return r }
            }
            for k in 0...dist {
                if let r = isValid(x: sensor.x - k, y: sensor.y + dist + 1 - k) { return r }
            }
        }
        return ""
    }
}
