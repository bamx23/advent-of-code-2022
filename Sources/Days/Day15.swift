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
    
    typealias Pos = (x: Int, y: Int)
    
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
    
    public func part01() {
        let measures = parse()
        for y in [10, 2000000] {
            let ranges = measures.compactMap { (sensor, beacon) -> ClosedRange<Int>? in
                let dist = abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
                let yDist = abs(sensor.y - y)
                let xDist = dist - yDist
                guard xDist >= 0 else { return nil }
                return (sensor.x - xDist)...(sensor.x + xDist)
            }
            var xPoses = Set<Int>()
            for range in ranges {
                xPoses.formUnion(range)
            }
            for (_, beacon) in measures {
                if beacon.y == y {
                    xPoses.remove(beacon.x)
                }
            }
//            if xPoses.count < 30 {
//                print(xPoses.sorted())
//            }
            print("y=\(y): \(xPoses.count)")
        }
    }
    
    public func part02() {
        let measures = parse()
        let len = measures.count <= 15 ? 20 : 4000000
        for y in 0...len {
            var x = 0
            while x <= len {
                var found = false
                for (sensor, beacon) in measures {
                    let distEx = abs(sensor.x - beacon.x) + abs(sensor.y - beacon.y)
                    let distNew = abs(sensor.x - x) + abs(sensor.y - y)
                    if distNew <= distEx {
                        found = true
                        let yDist = abs(sensor.y - y)
                        let xDist = distEx - yDist
                        x = sensor.x + xDist + 1
                        break
                    }
                }
                if !found {
                    print("x=\(x), y=\(y), freq=\(x * 4000000 + y)")
                    return
                }
            }
        }
    }
}
