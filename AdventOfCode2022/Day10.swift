//
//  Day10.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

struct Day10: Day {
    var input: String
    
    enum Cmd {
        case noop
        case add(Int)
    }
    
    func parse() -> [Cmd] {
        input
            .split(separator: "\n")
            .map { line in
                let pair = line.split(separator: " ")
                switch pair[0] {
                case "noop":
                    return .noop
                case "addx":
                    return .add(Int(pair[1])!)
                default:
                    fatalError()
                }
            }
    }
    
    func part01() {
        let cmds = parse()
        var x = 1
        var cycle = 1
        var result = 0
        
        func cycleInc() {
            if [20, 60, 100, 140, 180, 220].contains(cycle) {
                result += cycle * x
            }
            cycle += 1
        }
        
        for cmd in cmds {
            switch cmd {
            case .noop:
                cycleInc()
            case .add(let val):
                cycleInc()
                cycleInc()
                x += val
            }
        }
        print(result)
    }
    
    func part02() {
        let cmds = parse()
        var x = 1
        var pixIdx = 0
        var result = ""
        
        func cycleInc() {
            let pixX = pixIdx % 40
            let isShown = x - 1 <= pixX && pixX <= x + 1
            result += isShown ? "#" : "."
            if pixX == 39 {
                result += "\n"
            }
            pixIdx += 1
        }
        
        for cmd in cmds {
            switch cmd {
            case .noop:
                cycleInc()
            case .add(let val):
                cycleInc()
                cycleInc()
                x += val
            }
        }
        print(result)
    }
}
