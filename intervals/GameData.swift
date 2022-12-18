//
//  GameData.swift
//  intervals
//
//  Created by Ionut on 16.12.2022.
//

import Foundation

class GameData: ObservableObject {
    static let selectedInstrument = Instrument(name: "", minNote: 45, maxNote: 72)
    private let glop = GlobalPreferences2.global
    
    @Published var totalGuesses = 0
    @Published var correctGuesses = 0
    @Published var currentGuess: Int?
    @Published var isGuessingState = true
    @Published var chosenIntervalSize = 1
    @Published var chosenRoot = 1

    @Published var recordAsked: [String: (asked: Int, guessed: Int)] = [:]
    func addRecord(noteRoot: Int, interval: Int, answer: Int) -> Void {
        let id = "\(noteRoot)-\(interval)"
        var old = recordAsked[id] ?? (0, 0)
        old.guessed += (answer == interval) ? 1 : 0
        old.asked += 1
        recordAsked[id] = old
    } //func
    init() {
        self.totalGuesses = 0
        self.correctGuesses = 0
        self.currentGuess = nil
        self.isGuessingState = true
        self.chosenIntervalSize = 0
        self.chosenRoot = 0
        self.recordAsked = [:]
        
        chooseNewSize( mustBeDifferent: glop.newIntervalMustBeDifferent)
    } //init
    func actionGuess(interval: Int)  {
        guard isGuessingState else {
            return
        }
        currentGuess = interval
        isGuessingState = false
        totalGuesses += 1
        correctGuesses += (currentGuess == chosenIntervalSize) ? 1 : 0
    } //func
    func actionAcknowledgeAndReset() {
        resetGuessingState()
        chooseNewSize( mustBeDifferent: glop.newIntervalMustBeDifferent)
    } //func
    func actionPlayChosen() {
        if glop.randomizeRootEachPlay {
            chooseNewRoot()
        }
        clampChosenIntToAllowedSize()
        playNow(root: chosenRoot, interval: chosenIntervalSize)
    } //func
    private func resetGuessingState() {
        isGuessingState = true
        currentGuess = nil
    } //func
    func playNow(root: Int, interval: Int) -> Void {
        let i = NoteInterval(rootNote: root, size: interval)
        _ = Self.selectedInstrument.playInterval(i, with: 0.75)
    } //func
    private func chooseNewRoot() {
        var newVal = Int.random(in: Self.selectedInstrument.minNote ... Self.selectedInstrument.maxIntervalRoot(for: chosenIntervalSize))
        while (Self.selectedInstrument.minNote < Self.selectedInstrument.maxIntervalRoot(for: chosenIntervalSize))
        && (newVal == chosenRoot) {
            newVal = Int.random(in: Self.selectedInstrument.minNote ... Self.selectedInstrument.maxIntervalRoot(for: chosenIntervalSize))
        }
        chosenRoot = newVal
    } //func
    private func chooseNewSize(mustBeDifferent: Bool) {
        var newVal = Int.random(in: 1 ... self.glop.maxSizeToRandomize)
        while mustBeDifferent
                && (1 < self.glop.maxSizeToRandomize)
                && (newVal == chosenIntervalSize) {
            newVal = Int.random(in: 1 ... self.glop.maxSizeToRandomize)
        }
        chosenIntervalSize = newVal
        if glop.changeRootEveryIntervalChange {
            chooseNewRoot()
        }
    } //func
    private func clampChosenIntToAllowedSize() {
        if !(1 ... self.glop.maxSizeToRandomize).contains(chosenIntervalSize) {
            chooseNewSize(mustBeDifferent: false)
        }
        if !(Self.selectedInstrument.minNote ... Self.selectedInstrument.maxIntervalRoot(for: chosenIntervalSize)).contains(chosenRoot) {
            chooseNewRoot()
        }
    } //func
} //cl
