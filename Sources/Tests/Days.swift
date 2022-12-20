//
//  Days.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 19/12/2022.
//

import XCTest
import Days
import Input
import Shared

struct TestData {
    typealias DayResult = (part1: String, part2: String)
    
    let taskData: TaskData
    let resultData: ResultData
    
    init(day: Int) {
        taskData = FileTaskData(day: day)
        resultData = FileResultData(day: day)
    }
}

final class Days: XCTestCase {
    
    func testDay<D: Day>(dayType: D.Type, data: TestData) {
        func run(day: D, kind: DataKind) {
            if let result = data.resultData.results[.init(part: .part1, kind: kind)] {
                XCTAssertEqual(day.part01(), result, "\(D.self) has incorrect result for part 1 in \(kind)")
            }
            if let result = data.resultData.results[.init(part: .part2, kind: kind)] {
                XCTAssertEqual(day.part02(), result, "\(D.self) has incorrect result for part 2 in \(kind)")
            }
        }
        
        for (idx, sample) in data.taskData.samples.enumerated() {
            let day = dayType.init(input: sample)
            run(day: day, kind: .sample(idx: idx))
        }
        
        if let task = data.taskData.task {
            let day = dayType.init(input: task)
            run(day: day, kind: .task)
        }
    }

    func testDay01() throws {
        testDay(dayType: Day01.self, data: TestData(day: 1))
    }
    
    func testDay02() throws {
        testDay(dayType: Day02.self, data: TestData(day: 2))
    }
    
    func testDay03() throws {
        testDay(dayType: Day03.self, data: TestData(day: 3))
    }
    
    func testDay04() throws {
        testDay(dayType: Day04.self, data: TestData(day: 4))
    }
    
    func testDay05() throws {
        testDay(dayType: Day05.self, data: TestData(day: 5))
    }
    
    func testDay06() throws {
        testDay(dayType: Day06.self, data: TestData(day: 6))
    }
    
    func testDay07() throws {
        testDay(dayType: Day07.self, data: TestData(day: 7))
    }
    
    func testDay08() throws {
        testDay(dayType: Day08.self, data: TestData(day: 8))
    }
    
    func testDay09() throws {
        testDay(dayType: Day09.self, data: TestData(day: 9))
    }
    
    func testDay10() throws {
        testDay(dayType: Day10.self, data: TestData(day: 10))
    }
    
    func testDay11() throws {
        testDay(dayType: Day11.self, data: TestData(day: 11))
    }
    
    func testDay12() throws {
        testDay(dayType: Day12.self, data: TestData(day: 12))
    }
    
    func testDay13() throws {
        testDay(dayType: Day13.self, data: TestData(day: 13))
    }
    
    func testDay14() throws {
        testDay(dayType: Day14.self, data: TestData(day: 14))
    }
    
    func testDay15() throws {
        testDay(dayType: Day15.self, data: TestData(day: 15))
    }
    
    func testDay16() throws {
        testDay(dayType: Day16.self, data: TestData(day: 16))
    }
    
    func testDay17() throws {
        testDay(dayType: Day17.self, data: TestData(day: 17))
    }
    
    func testDay18() throws {
        testDay(dayType: Day18.self, data: TestData(day: 18))
    }
    
    func testDay19() throws {
        testDay(dayType: Day19.self, data: TestData(day: 19))
    }
    
    func testDay20() throws {
        testDay(dayType: Day20.self, data: TestData(day: 20))
    }

}
