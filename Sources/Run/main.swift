//
//  main.swift
//  AdventOfCode2022
//
//  Created by Nikolay Valasatau on 1.12.22.
//

import Days
import Shared
import Input

let dayType = allDays.max(by: { $0.number < $1.number })!
runDay(dayType: dayType, data: FileTaskData(day: dayType.number))
