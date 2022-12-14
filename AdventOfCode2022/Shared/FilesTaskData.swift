//
//  FilesTaskData.swift
//  AdventOfCode2022
//
//  Created by Nikolay Volosatov on 14/12/2022.
//

import Foundation

struct FileTaskData: TaskData {
    var day: Int
    
    var samples: [String] {
        let prefix = "sample"
        var result = [String]()
        var idx = 1
        while true {
            guard let data = Self.readInput(prefix: prefix, num: String(format: "%02d_%02d", day, idx)) else { break }
            result.append(data)
            idx += 1
        }
        if result.isEmpty, let data = Self.readInput(prefix: prefix, num: String(format: "%02d", day)) {
            result.append(data)
        }
        return result
    }
    
    var task: String? {
        Self.readInput(prefix: "task", num: String(format: "%02d", day))
    }

    static private func readInput(prefix: String, num: String) -> String? {
        let name = "\(prefix)\(num)"
        guard let url = Bundle.main.url(forResource: name, withExtension: "txt", subdirectory: "input")
        else {
            return nil
        }
        return try? String(contentsOf: url)
    }
}
