//
//  Day19.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 19/12/2022.
//

import Foundation
import Shared

public struct Day19: Day {
    static public let number = 19

    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    struct Blueprint {
        /// ore
        var oreBot: Int
        /// ore
        var clayBot: Int
        /// (ore, clay)
        var obsidianBot: (Int, Int)
        /// (ore, obsidian)
        var geodeBot: (Int, Int)
    }
    
    func parse() -> [Blueprint] {
        input
            .split(separator: "\n")
            .map { line in
                let costs = line
                    .split(separator: ":")[1]
                    .split(separator: ".")
                    .map { costStr in
                        costStr
                            .split(separator: " ")
                            .compactMap { Int($0) }
                    }
                return .init(
                    oreBot: costs[0][0],
                    clayBot: costs[1][0],
                    obsidianBot: (costs[2][0], costs[2][1]),
                    geodeBot: (costs[3][0], costs[3][1])
                )
            }
    }
    
    struct State: Hashable {
        var ore: Int
        var clay: Int
        var obsidian: Int
        var geode: Int
        
        var oreBots: Int
        var clayBots: Int
        var obsidianBots: Int
        var geodeBots: Int
        
        var timeLeft: Int
        
        init(oreBots: Int, timeLeft: Int) {
            self.ore = 0
            self.clay = 0
            self.obsidian = 0
            self.geode = 0
            self.oreBots = oreBots
            self.clayBots = 0
            self.obsidianBots = 0
            self.geodeBots = 0
            self.timeLeft = timeLeft
        }
    }
    
    func harvest(_ state: inout State) {
        state.ore += state.oreBots
        state.clay += state.clayBots
        state.obsidian += state.obsidianBots
        state.geode += state.geodeBots
        state.timeLeft -= 1
    }
    
    func runOpt(bp: Blueprint, state: State) -> (result: Int, geode: State?, obsidian: State?, clay: State?, ore: State?) {
        var state = state
        
        // ore, clay, obsidian, geode
        var firstStates: [State?] = [nil, nil, nil, nil]
        var firstsLeft = 2
        + (state.obsidianBots != 0 ? 1 : 0)
        + (state.clayBots != 0 ? 1 : 0)
        
        if state.timeLeft >= 2 {
            for _ in 0..<(state.timeLeft - 1) {
                if firstsLeft != 0 {
                    if state.ore >= bp.geodeBot.0 && state.obsidian >= bp.geodeBot.1 {
                        if firstStates[3] == nil {
                            firstStates[3] = state
                            firstsLeft -= 1
                        }
                    }
                    
                    if state.ore >= bp.obsidianBot.0 && state.clay >= bp.obsidianBot.1 {
                        if firstStates[2] == nil {
                            firstStates[2] = state
                            firstsLeft -= 1
                        }
                    }
                    
                    if state.ore >= bp.clayBot {
                        if firstStates[1] == nil {
                            firstStates[1] = state
                            firstsLeft -= 1
                        }
                    }
                    
                    if state.ore >= bp.oreBot {
                        if firstStates[0] == nil {
                            firstStates[0] = state
                            firstsLeft -= 1
                        }
                    }
                } else if state.geodeBots == 0 {
                    break
                }
                
                harvest(&state)
            }
        }
        harvest(&state)
        return (state.geode, firstStates[3], firstStates[2], firstStates[1], firstStates[0])
    }
    
    func run(bp: Blueprint, state: State, cache: inout [State: Int], curMax: inout Int) -> Int {
        if state.geode + state.timeLeft * (2 * state.geodeBots + state.timeLeft - 1) / 2 < curMax {
            return 0
        }
        if let result = cache[state] { return result }
        
        let opt = runOpt(bp: bp, state: state)
        
        var result = opt.result
        curMax = max(curMax, result)

        if var geodeBot = opt.geode {
            harvest(&geodeBot)
            geodeBot.geodeBots += 1
            geodeBot.ore -= bp.geodeBot.0
            geodeBot.obsidian -= bp.geodeBot.1
            
            result = max(result, run(bp: bp, state: geodeBot, cache: &cache, curMax: &curMax))
        }
        if var obsidianState = opt.obsidian {
            harvest(&obsidianState)
            obsidianState.obsidianBots += 1
            obsidianState.ore -= bp.obsidianBot.0
            obsidianState.clay -= bp.obsidianBot.1
            
            result = max(result, run(bp: bp, state: obsidianState, cache: &cache, curMax: &curMax))
        }
        if var clayState = opt.clay {
            harvest(&clayState)
            clayState.clayBots += 1
            clayState.ore -= bp.clayBot
            
            result = max(result, run(bp: bp, state: clayState, cache: &cache, curMax: &curMax))
        }
        if var oreState = opt.ore {
            harvest(&oreState)
            oreState.oreBots += 1
            oreState.ore -= bp.oreBot
            
            result = max(result, run(bp: bp, state: oreState, cache: &cache, curMax: &curMax))
        }
        
        cache[state] = result
        return result
    }
    
    public func part01() -> String {
        let bps = parse()
        let score = bps
            .enumerated()
            .map { (idx, bp) in
                var cache: [State: Int] = [:]
                var curMax = Int.min
                let geodes = run(
                    bp: bp,
                    state: .init(oreBots: 1, timeLeft: 24),
                    cache: &cache,
                    curMax: &curMax
                )
//                print("\(idx + 1): \(geodes)")
                return (idx + 1) * geodes
            }
            .reduce(0, +)
        return "\(score)"
    }
    
    public func part02() -> String {
        let bps = parse()
        let score = bps
            .prefix(3)
            .map { bp in
                var cache: [State: Int] = [:]
                var curMax = Int.min
                let geodes = run(
                    bp: bp,
                    state: .init(oreBots: 1, timeLeft: 32),
                    cache: &cache,
                    curMax: &curMax
                )
//                print(geodes)
                return geodes
            }
            .reduce(1, *)
        return "\(score)"
    }
}
