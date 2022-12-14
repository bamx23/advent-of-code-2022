//
//  Day02.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation
import Shared

public struct Day02: Day {
    let input: String
    
    public init(input: String) {
        self.input = input
    }
    
    enum Figure {
        case rock
        case paper
        case scissors
    }
    
    func parse() -> [(Figure, Figure)] {
        input
            .split(separator: "\n")
            .map { line in
                let pair = line.split(separator: " ")
                return (.fromTheir(pair[0]), .fromYour(pair[1]))
            }
    }
    
    public func part01() {
        let plan = parse()
        let score = plan
            .map { (a, b) in b.vs(a).rawValue + b.score }
            .reduce(0, +)
        print(score)
    }
    
    public func part02() {
        let plan = parse()
        let score = plan
            .map { (a, b) in (a, b.correctParsing) }
            .map { (a, b) in b.rawValue + a.how(b).score }
            .reduce(0, +)
        print(score)
    }
}

extension Day02.Figure {
    var score: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .scissors:
            return 3
        }
    }
    
    static func fromTheir(_ str: Substring) -> Self {
        switch str {
        case "A":
            return .rock
        case "B":
            return .paper
        case "C":
            return .scissors
        default:
            fatalError()
        }
    }
    
    static func fromYour(_ str: Substring) -> Self {
        switch str {
        case "X":
            return .rock
        case "Y":
            return .paper
        case "Z":
            return .scissors
        default:
            fatalError()
        }
    }
    
    enum Result: Int {
        case win = 6
        case lose = 0
        case draw = 3
    }
    
    func vs(_ other: Self) -> Result {
        switch (self, other) {
        case (.rock, .paper):
            return .lose
        case (.rock, .scissors):
            return .win
        case (.paper, .scissors):
            return .lose
        case (.paper, .rock):
            return .win
        case (.scissors, .rock):
            return .lose
        case (.scissors, .paper):
            return .win
        default:
            return .draw
        }
    }
    
    func how(_ result: Result) -> Self {
        switch (self, result) {
        case (_, .draw):
            return self
        case (.rock, .win):
            return .paper
        case (.rock, .lose):
            return .scissors
        case (.paper, .win):
            return .scissors
        case (.paper, .lose):
            return .rock
        case (.scissors, .win):
            return .rock
        case (.scissors, .lose):
            return .paper
        }
    }
    
    var correctParsing: Result {
        switch self {
        case .rock:
            return .lose
        case .paper:
            return .draw
        case .scissors:
            return .win
        }
    }
}
