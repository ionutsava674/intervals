//
//  GameData.swift
//  intervals
//
//  Created by Ionut on 16.12.2022.
//

import Foundation

class GameData: ObservableObject {
    @Published var totalGuesses = 0
    @Published var correctGuesses = 0
    @Published var currentGuess: Int?
    @Published var isGuessingState = true
    @Published var recordAsked: [String: (asked: Int, guessed: Int)] = [:]
    func addRecord(noteRoot: Int, interval: Int, answer: Int) -> Void {
        let id = "\(noteRoot)-\(interval)"
        var old = recordAsked[id] ?? (0, 0)
        old.guessed += (answer == interval) ? 1 : 0
        old.asked += 1
        recordAsked[id] = old
    } //func
} //cl
