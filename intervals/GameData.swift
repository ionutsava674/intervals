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
    
    @Published var currentGuess: Int?
    @Published var isGuessingState = true
    
    @Published var chosenIntervalSize = 1
    @Published var chosenRoot = 1
    @Published var chosenIntervalTimesPlayed: Int = 0
    
    @Published var startTime: Date
    @Published var endTime: Date?
    @Published var finalEndTime: Date?
    
    @Published var questionTarget: Int
    @Published var questionCounter: Int
    @Published var correctGuessCounter: Int
    enum GameStateType: Int {
        case playing, summary, revisiting
    } //enum
    @Published public private(set) var gameState: GameStateType

    typealias Answer = (interval: Int, playedBeforeAnswer: Int)
    @Published var allQuestions: [NoteInterval: [Answer]]
    var totalDistinctQuestions: Int {
        allQuestions.count
    } //cv
    var correctDistinctGuesses: Int {
        allQuestions.filter { question in
            question.value.last?.interval == question.key.size
        } //filt
        .count
    } //cv
    var wrongDistinctGuesses: Int {
        allQuestions.filter { question in
            question.value.last?.interval != question.key.size
        } //filt
        .count
    } //cv
    
    @Published var revisitationQuestions: [(asked: NoteInterval, answered: Bool)]
    var revisitationCurrentIndex: Int? {
        revisitationQuestions.firstIndex {
            !$0.answered
        }
    } //cv
    var revisitationsLeft: Bool {
        !(revisitationQuestions.filter({
            !$0.answered
        }).isEmpty)
    } //cv
    var revisitationCurrentInterval: NoteInterval? {
        revisitationQuestions.first(where: {
            !$0.answered
        })?.asked
    } //cv
    func actionEnterRevisitation() {
        guard canRevisit() else {
            return
        }
        gameState = .revisiting
        revisitationQuestions = getWrongAnswers()
        resetGuessingState()
    }
    func actionPlayCurrentRevisitation() {
        guard let currentReInterval = revisitationCurrentInterval else {
            return
        } //gua
        chosenIntervalTimesPlayed += 1
        playNow(root: currentReInterval.rootNote, interval: currentReInterval.size)
    } //func
    func actionReGuess(interval: Int)  {
        guard isGuessingState,
              let currentRevNote = revisitationCurrentInterval
        else {
            return
        }
        currentGuess = interval
        addAnswer(intervalRoot: currentRevNote.rootNote, intervalSize: currentRevNote.size, answeredSize: interval, timesPlayed: chosenIntervalTimesPlayed)
        isGuessingState = false
        if (revisitationCurrentIndex ?? -1) == (revisitationQuestions.endIndex - 1) {
            //end revisit
            finalEndTime = .now
            return
        } //gua
    } //func
    func actionAcknowledgeRevisitation() {
        guard let currentRevIndex = revisitationCurrentIndex else {
            return
        } //gua
        revisitationQuestions[currentRevIndex].answered = true
        resetGuessingState()
        guard revisitationsLeft else {
            //end revisit
            gameState = .summary
            return
        } //gua
    } //func
    init(questionTarget: Int = 0) {
        self.currentGuess = nil
        self.isGuessingState = true
        self.chosenIntervalSize = 0
        self.chosenRoot = 0
        
        self.questionTarget = questionTarget
        self.questionCounter = 0
        self.correctGuessCounter = 0
        
        gameState = .playing
        allQuestions = [:]
        revisitationQuestions = []
        
        self.endTime = nil
        self.finalEndTime = nil
        self.startTime = Date.now
        chooseNewRoot()
        chooseNewSize( mustBeDifferent: glop.newIntervalMustBeDifferent)
    } //init
    func actionGuess(interval: Int)  {
        guard isGuessingState else {
            return
        }
        currentGuess = interval
        addAnswer(intervalRoot: chosenRoot, intervalSize: chosenIntervalSize, answeredSize: interval, timesPlayed: chosenIntervalTimesPlayed)
        questionCounter += 1
        correctGuessCounter += (currentGuess == chosenIntervalSize) ? 1 : 0

        isGuessingState = false
        guard !checkTargetReached() else {
            //end game
            endTime = .now
            return
        }
    } //func
    func actionAcknowledgeAndReset() {
        guard !checkTargetReached() else {
            //end game
            gameState = .summary
            return
        }
        resetGuessingState()
        chooseNewSize( mustBeDifferent: glop.newIntervalMustBeDifferent)
    } //func
    func fromPlayingToSummary() {
        endTime = .now
        gameState = .summary
    }
    func actionPlayChosen() {
        if glop.randomizeRootEachPlay {
            chooseNewRoot()
        }
        clampChosenIntToAllowedSize()
        chosenIntervalTimesPlayed += 1
        playNow(root: chosenRoot, interval: chosenIntervalSize)
    } //func
    func addAnswer(intervalRoot: Int, intervalSize: Int, answeredSize: Int, timesPlayed: Int) {
        let note = NoteInterval(rootNote: intervalRoot, size: intervalSize)
            let ans = Answer(interval: answeredSize, playedBeforeAnswer: timesPlayed)
        var newAnswerList = (allQuestions[note] ?? [Answer]())
        newAnswerList.append(ans)
        allQuestions[note] = newAnswerList
    } //func
    func getWrongAnswers() -> [(asked: NoteInterval, answered: Bool)] {
        let w: [(asked: NoteInterval, answered: Bool)] = allQuestions.filter { question in
            question.value.last?.interval != question.key.size
        } //filt
            .map {
                return ($0.key, false)
            }
        return w
    } //func
    func canRevisit() -> Bool {
        return gameState == .summary
        && (wrongDistinctGuesses > 0)
    } //func
    private func checkTargetReached() -> Bool {
        guard questionTarget > 0 else {
            return false
        } //gua
        return questionCounter >= questionTarget
    }
    private func resetGuessingState() {
        isGuessingState = true
        currentGuess = nil
        chosenIntervalTimesPlayed = 0
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
