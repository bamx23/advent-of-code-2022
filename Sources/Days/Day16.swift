//
//  Day16.swift
//  
//
//  Created by Nikolay Volosatov on 15/12/2022.
//

import Foundation
import Shared

public struct Day16: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    class Valve {
        let idx: Int
        let name: String
        let flow: Int
        var otherIdxs: [Int]
        
        init(idx: Int, name: String, flow: Int) {
            self.idx = idx
            self.name = name
            self.flow = flow
            self.otherIdxs = []
        }
    }
    
    struct State: Hashable {
        var currentValveIdx: Int
        var timeLeft: Int
        var totalFlow: Int
        var currentFlow: Int
        var openValves: Set<Int>
    }
    
    func parse() -> [Valve] {
        let valves = input
            .split(separator: "\n")
            .enumerated()
            .map { (idx, line) -> (Valve, [String]) in
                let words = line.split(separator: " ")
                let name = String(words[1])
                let flow = Int(words[4].dropLast().split(separator: "=")[1])!
                let otherNames = words
                    .dropFirst(9)
                    .map { $0.hasSuffix(",") ? $0.dropLast() : $0 }
                    .map { String($0) }
                return (.init(idx: idx, name: name, flow: flow), otherNames)
            }
        for (valve, otherNames) in valves {
            valve.otherIdxs = otherNames.map { n in valves.firstIndex(where: { $0.0.name == n })! }
        }
        return valves.map(\.0)
    }
    
    func run(valves: [Valve], maxOpen: Int, maxFlow: Int, state: State, cache: inout [State: Int], currentMax: inout Int) -> Int {
        guard currentMax < state.totalFlow + state.timeLeft * maxFlow else {
            return 0
        }
        if let result = cache[state] { return result }
        guard state.timeLeft > 0 else {
            currentMax = max(currentMax, state.totalFlow)
            return state.totalFlow
        }
        guard state.openValves.count < maxOpen else {
            let result = state.totalFlow + state.timeLeft * state.currentFlow
            currentMax = max(currentMax, result)
            return result
        }
        
        let valve = valves[state.currentValveIdx]
        
        var result = 0
        var newState = state
        newState.totalFlow += state.currentFlow
        newState.timeLeft -= 1
        
        for otherIdx in valve.otherIdxs {
            newState.currentValveIdx = otherIdx
            result = max(result, run(
                valves: valves,
                maxOpen: maxOpen,
                maxFlow: maxFlow,
                state: newState,
                cache: &cache,
                currentMax: &currentMax
            ))
        }
        
        newState.currentValveIdx = state.currentValveIdx
        if valve.flow != 0 && !state.openValves.contains(valve.idx) {
            newState.openValves.insert(valve.idx)
            newState.currentFlow += valve.flow
            result = max(result, run(
                valves: valves,
                maxOpen: maxOpen,
                maxFlow: maxFlow,
                state: newState,
                cache: &cache,
                currentMax: &currentMax
            ))
        }
        
        cache[state] = result
        return result
    }
    
    struct StateWithEl: Hashable {
        var myTargetIdx: Int
        var myTargetLeft: Int
        
        var elTargetIdx: Int
        var elTargetLeft: Int
        
        var timeLeft: Int
        var totalFlow: Int
        var currentFlow: Int
        var openCount: Int
        var openValves: UInt64
        
        func isOpen(_ idx: Int) -> Bool {
            openValves & (1 << idx) != 0
        }
        
        mutating func toggle(_ idx: Int) {
            openValves ^= (1 << idx)
        }
    }
    
    typealias FastEdge = (idx: Int, steps: Int)
    typealias FastEdges = [[FastEdge]]
    
    func runWithEl(valves: [Valve], maxOpen: Int, maxFlow: Int, fastEdges: FastEdges, state: StateWithEl, cache: inout [StateWithEl: Int], currentMax: inout Int) -> Int {
        guard currentMax < state.totalFlow + state.timeLeft * maxFlow else {
            return 0
        }
        if let result = cache[state] { return result }
        guard state.timeLeft > 0 else {
            if currentMax < state.totalFlow {
                currentMax = state.totalFlow
//                print(currentMax)
            }
            return state.totalFlow
        }
        guard state.openCount < maxOpen else {
            let result = state.totalFlow + state.timeLeft * state.currentFlow
            if currentMax < result {
                currentMax = result
//                print(currentMax)
            }
            return result
        }
        
        var result = 0
        
        var myMoves = state.myTargetLeft == 0
            ? fastEdges[state.myTargetIdx]
                .filter { (idx, steps) in
                    state.timeLeft >= steps && idx != state.elTargetIdx && !state.isOpen(idx)
                }
            : [(state.myTargetIdx, state.myTargetLeft)]
        if myMoves.isEmpty {
            myMoves.append((-1, state.timeLeft))
        }
        var elMoves = state.elTargetLeft == 0
            ? fastEdges[state.elTargetIdx]
                .filter { (idx, steps) in
                    state.timeLeft >= steps && idx != state.myTargetIdx && !state.isOpen(idx)
                }
            : [(state.elTargetIdx, state.elTargetLeft)]
        if elMoves.isEmpty {
            elMoves.append((-1, state.timeLeft))
        }
        
        for myMove in myMoves {
            for elMove in elMoves {
                if elMove.idx == myMove.idx && elMove.idx != -1 { continue }
                
                var newState = state
                let steps = min(myMove.steps, elMove.steps)
                newState.myTargetIdx = myMove.idx
                newState.myTargetLeft = myMove.steps - steps
                newState.elTargetIdx = elMove.idx
                newState.elTargetLeft = elMove.steps - steps
                
                newState.timeLeft -= steps
                newState.totalFlow += steps * state.currentFlow
                if steps == myMove.steps && myMove.idx != -1 {
                    newState.toggle(myMove.idx)
                    newState.openCount += 1
                    newState.currentFlow += valves[myMove.idx].flow
                }
                if steps == elMove.steps && elMove.idx != -1 {
                    newState.toggle(elMove.idx)
                    newState.openCount += 1
                    newState.currentFlow += valves[elMove.idx].flow
                }
                
                result = max(result, runWithEl(
                    valves: valves,
                    maxOpen: maxOpen,
                    maxFlow: maxFlow,
                    fastEdges: fastEdges,
                    state: newState,
                    cache: &cache,
                    currentMax: &currentMax
                ))
            }
        }
        
        cache[state] = result
        return result
    }
    
    func shrink(valves: [Valve]) -> FastEdges {
        var result = FastEdges()
        for valve in valves {
            var distances = [Int](repeating: -1, count: valves.count)
            var distance = 1
            var queue: [Int?] = [valve.idx, nil]
            while true {
                guard let v = queue.removeFirst() else {
                    if queue.isEmpty { break }
                    distance += 1
                    queue.append(nil)
                    continue
                }
                guard distances[v] == -1 else { continue }
                distances[v] = distance
                queue.append(contentsOf: valves[v].otherIdxs.filter { distances[$0] == -1 })
            }
            result.append(distances.enumerated().compactMap { (idx, dist) in
                if valves[idx].flow == 0 || idx == valve.idx { return nil }
                return (idx: idx, steps: dist)
            })
        }
        return result
    }
    
    public func part01() {
        let valves = parse()
        var cache = [State: Int]()
        var currentMax = 0
        let maxFlow = run(
            valves: valves,
            maxOpen: valves.filter { $0.flow != 0 }.count,
            maxFlow: valves.map(\.flow).reduce(0, +),
            state: .init(
                currentValveIdx: valves.firstIndex(where: { $0.name == "AA" })!,
                timeLeft: 30,
                totalFlow: 0,
                currentFlow: 0,
                openValves: .init()
            ),
            cache: &cache,
            currentMax: &currentMax
        )
        print(maxFlow)
    }
    
    public func part02() {
        let valves = parse()
        var cache = [StateWithEl: Int]()
        var currentMax = 0
        let maxFlow = runWithEl(
            valves: valves,
            maxOpen: valves.filter { $0.flow != 0 }.count,
            maxFlow: valves.map(\.flow).reduce(0, +),
            fastEdges: shrink(valves: valves),
            state: .init(
                myTargetIdx: valves.firstIndex(where: { $0.name == "AA" })!,
                myTargetLeft: 0,
                elTargetIdx: valves.firstIndex(where: { $0.name == "AA" })!,
                elTargetLeft: 0,
                timeLeft: 26,
                totalFlow: 0,
                currentFlow: 0,
                openCount: 0,
                openValves: 0
            ),
            cache: &cache,
            currentMax: &currentMax
        )
        print(maxFlow)
    }
}
