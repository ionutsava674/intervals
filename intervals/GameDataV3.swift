//
//  GameDataV3.swift
//  intervals
//
//  Created by Ionut Sava on 24.02.2023.
//

import Foundation

@MainActor
class GameDataV3: ObservableObject {
    class Question {
    let interval: NoteIntervalV3
        var answer: Int?
        var timesPlayed: Int = 0
        var answered: Bool {
            answer != nil
        } //cv
        var answeredCorrectly: Bool {
            guard let ans = answer else {
                return false
            } //gua
            return ans == Swift.abs( interval.size)
        } //cv

        init(interval: NoteIntervalV3, answer: Int? = nil, timesPlayed: Int = 0) {
            self.interval = interval
            self.answer = answer
            self.timesPlayed = timesPlayed
        } //init
    } //cl //init
    private let glop = GlobalPreferences2.global
    var selectedInstrument: InstrumentV3

    private var limitlessGame: Bool
    @Published var questionList: [Question]
    @Published var initialQuestions: [Question]
    @Published var completedQuestions: [Question]
    @Published var currentQuestionIndex: Int
    @Published var questionsStarted: Bool

    @Published var currentQuestionTimesPlayed: Int
    @Published var currentAnswer: Int?
    @Published var isGuessingState: Bool

    @Published var startTime: Date
    @Published var endTime: Date?
    @Published var finalEndTime: Date?

    enum GameStateType: Int {
        case playing, summary
    } //enum
    @Published public private(set) var gameState: GameStateType
    var canGuessAnswer: Bool {
        currentQuestionTimesPlayed > 0
    } //cv
    var currentAnsweredCorrectly: Bool {
        guard questionsStarted,
              !isGuessingState,
              questionList.indices.contains(currentQuestionIndex)
        else {
            return false
        } //gua
        return currentAnswer == Swift.abs(questionList[currentQuestionIndex].interval.size)
    } //cv
    var correctAnswer: String {
        guard questionsStarted,
              !isGuessingState,
              questionList.indices.contains(currentQuestionIndex)
        else {
            return ""
        } //gua
        var after = "(same note)"
        if questionList[currentQuestionIndex].interval.size > 0 {
            after = "(ascending)"
        } else if questionList[currentQuestionIndex].interval.size < 0 {
            after = "(descending)"
        }
        return "\(Swift.abs( questionList[currentQuestionIndex].interval.size)) \(after)"
    } //cv
    var answeredQuestions: [Question] {
        questionList.answered
    } //cv
    var correctlyAnsweredQuestions: [Question] {
        questionList.correctlyAnswered
    } //cv
    var success: Bool {
        gameState == .summary
        && correctlyAnsweredQuestions.count == questionList.count
    } //cv
    var canRevisit: Bool {
        gameState == .summary
        && !questionList.isEmpty
    } //cv
    init(questionTargetCount: Int = 0, instrumentName: String = "") {
        let instData = GlobalPreferences2.availableInstruments[instrumentName] ?? ("", 0, 0)
        self.selectedInstrument = InstrumentV3(name: instrumentName, minNote: instData.minNote, maxNote: instData.maxNote)

        self.endTime = nil
        self.finalEndTime = nil
        self.startTime = Date.now

        limitlessGame = (questionTargetCount == 0)
        questionList = []
        initialQuestions = []
        completedQuestions = []
        currentQuestionIndex = 0
        questionsStarted = false

        currentQuestionTimesPlayed = 0
        currentAnswer = nil
        isGuessingState = false

        gameState = .playing

        generateQuestions(targetCount: questionTargetCount)
        fetchNewQuestion()
    } //init
    func actionPlay() {
        guard questionsStarted else {
            print("ns \(questionList.count)")
            return
        }
        var i = questionList[currentQuestionIndex].interval
        if glop.randomizeRootEachPlay {
            let newRoot = self.getNewRoot(for: i.size)
            i = NoteIntervalV3(rootNote: newRoot, size: i.size)
        }
        currentQuestionTimesPlayed += 1
        _ = self.selectedInstrument.playInterval( i, with: glop.getIntervalTime)
    } //func
    func actionCustomPlay(_ interval: Int) {
        guard questionsStarted,
              !isGuessingState else {
            return
        }
        var i = questionList[ currentQuestionIndex].interval
        let asc = i.secondNote >= i.rootNote
        let newSize = asc ? interval : -interval
        let newRoot = glop.randomizeRootEachPlay ? self.getNewRoot(for: newSize) : i.rootNote
        i = NoteIntervalV3(rootNote: newRoot, size: newSize)
        _ = self.selectedInstrument.playInterval( i, with: glop.getIntervalTime)
    } //func
    func actionGuess( _ intervalSize: Int) {
        guard isGuessingState,
              questionList.indices.contains(currentQuestionIndex) else {
            return
        } //gua
        questionList[currentQuestionIndex].answer = intervalSize
        questionList[currentQuestionIndex].timesPlayed = currentQuestionTimesPlayed
        currentAnswer = intervalSize
        isGuessingState = false
    } //func
    func actionNextQuestion() -> Void {
        guard questionsStarted,
              !isGuessingState else {
            return
        }
        if canFetchNewQuestion() {
            fetchNewQuestion()
        } else {
            gotoSummary()
        } //else
    } //func
    func actionRevisit() {
        guard canRevisit else {
            return
        } //gua
        questionList.forEach { q in
            q.timesPlayed = 0
            q.answer = nil
        } //fe
        limitlessGame = false
        questionsStarted = false
        gameState = .playing
        fetchNewQuestion()
    } //func
    private func gotoSummary() {
        finalEndTime = .now
        if endTime == nil {
            endTime = finalEndTime
        }
        if initialQuestions.isEmpty {
            initialQuestions = questionList.map({
                Question(interval: $0.interval, answer: $0.answer, timesPlayed: $0.timesPlayed)
            })
        }
        completedQuestions.append( contentsOf: questionList.correctlyAnswered)
        questionList = questionList.wronglyAnswered
        gameState = .summary
    } //func
    private func fetchNewQuestion() {
        guard !limitlessGame else {
            fetchLimitless()
            return
        } //gua
        if !questionsStarted {
            questionsStarted = true
            currentQuestionIndex = 0
        } else {
            currentQuestionIndex += 1
        }
        resetCurrentAnswer()
    } //func
    private func resetCurrentAnswer() {
        currentAnswer = nil
        currentQuestionTimesPlayed = 0
        isGuessingState = true
    } //func
    private func fetchLimitless() {
        //tochange
        let chosenRoot = getNewRoot()
        let newSize = getNewIntervalSize()
        let newRoot = self.glop.changeRootEveryIntervalChange ? self.getNewRoot(for: newSize) : chosenRoot
        let interval = NoteIntervalV3(rootNote: newRoot, size: newSize)
        questionList.append( Question(interval: interval))
        currentQuestionIndex = questionList.count - 1
        questionsStarted = true
        resetCurrentAnswer()
    } //func
    private func canFetchNewQuestion() -> Bool {
        guard !limitlessGame else {
            return true
        } //gua
        return !questionsStarted || (currentQuestionIndex < (questionList.count - 1))
    } //func
    private func generateQuestions( targetCount: Int) {
        let chosenRoot = getNewRoot()
        questionList = [Int](repeating: 0, count: targetCount).map({ _ in
            let newSize = getNewIntervalSize()
            let newRoot = self.glop.changeRootEveryIntervalChange ? self.getNewRoot(for: newSize) : chosenRoot
            let interval = NoteIntervalV3(rootNote: newRoot, size: newSize)
            return Question(interval: interval)
        })
    } //func
    private func allowedIntervalRange() -> ClosedRange<Int> {
        let lowerBound = glop.onlyAscending ? 0 : (-glop.maxSizeToRandomize)
        return lowerBound ... (glop.maxSizeToRandomize)
    } //func
    private func getNewIntervalSize() -> Int {
        allowedIntervalRange().randomElement() ?? allowedIntervalRange().lowerBound
    } //func
    private func getNewRoot( for specificInterval: Int? = nil) -> Int {
        var intervalRange = self.allowedIntervalRange()
        if let specificInterval {
            intervalRange = specificInterval ... specificInterval
        }
        let range = selectedInstrument.rootRangeForIntervalSizeRange( intervalRange )
        return range.randomElement() ?? range.lowerBound
    } //func

} //cl

extension Array where Element == GameDataV3.Question {
    var correctlyAnswered: Self {
        filter({
            $0.answeredCorrectly
        }) //filt
    } //cv
    var wronglyAnswered: Self {
        filter({
            !$0.answeredCorrectly
        }) //filt
    } //cv
    var answered: Self {
        filter({
            $0.answered
        }) //filt
    } //cv
} //ext
