//
//  PlayData.swift
//  Project39
//
//  Created by Prarthana Das on 21/07/23.
//

import Foundation

class PlayData {
    var allWords = [String]()
   // var wordCounts = [String: Int]()
    var wordsCountsFaster: NSCountedSet!
    private(set) var filteredWords = [String]()
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted) //splits by anything that is not a character or number
                allWords = allWords.filter { $0 != "" }
//                for word in allWords {
//                    wordCounts[word, default: 0] += 1
//                }
//                allWords = Array(wordCounts.keys)
                
                wordsCountsFaster = NSCountedSet(array: allWords)
                let sorted = wordsCountsFaster.allObjects.sorted { wordsCountsFaster.count(for: $0) > wordsCountsFaster.count(for: $1) }
                allWords = sorted as! [String]
                
            }
            applyUserFilter("swift")
        }
    }
    
//    func applyUserFilter (_ input: String) {
//        if let userNumber = Int(input) {
//            filteredWords = allWords.filter {self.wordsCountsFaster.count(for: $0) >= userNumber}
//        } else {
//            filteredWords = allWords.filter {$0.range(of: input, options: .caseInsensitive) != nil }
//        }
//    }
    
    func applyUserFilter(_ input: String) {
        if let userNumber = Int(input) {
            applyFilter { self.wordsCountsFaster.count(for: $0) >= userNumber }
        } else {
            applyFilter { $0.range(of: input, options: .caseInsensitive) != nil }
        }
    }

    
    func applyFilter(_ filter: (String) -> Bool ) {
        filteredWords = allWords.filter(filter)
    }
    
}
