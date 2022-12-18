//
//  GameViewV1.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameViewV1: View {
    static let i1 = Instrument(name: "", minNote: 45, maxNote: 72)
    @State private var totalGuesses = 0
    @State private var correctGuesses = 0
    @State private var currentGuess: Int?
    @State private var isGuessingState = true
    var btnTitle: String {
        guard !isGuessingState else {
            return "give up"
        } //gua
        return currentGuess == chosenIntervalSize
        ? "correct (\(chosenIntervalSize)"
        : "wrong (\(chosenIntervalSize)"
    } //cv
    
    @State private var chosenIntervalSize = 1
    @State private var chosenRoot = 1
    
    @AccessibilityFocusState private var playFocused: Bool
    @AccessibilityFocusState private var correctFocused: Bool
    @State private var showingOptions = false
    @ObservedObject private var glop = GlobalPreferences2.global
    
    func resetGuessingState() {
        isGuessingState = true
        currentGuess = nil
    } //func
    func guess(interval: Int)  {
        guard isGuessingState else {
            return
        }
        currentGuess = interval
        isGuessingState = false
        totalGuesses += 1
        correctGuesses += (currentGuess == chosenIntervalSize) ? 1 : 0
    }
    func chooseNewRoot() {
        var newVal = Int.random(in: Self.i1.minNote ... Self.i1.maxIntervalRoot(for: chosenIntervalSize))
        while (Self.i1.minNote < Self.i1.maxIntervalRoot(for: chosenIntervalSize))
        && (newVal == chosenRoot) {
            newVal = Int.random(in: Self.i1.minNote ... Self.i1.maxIntervalRoot(for: chosenIntervalSize))
        }
        chosenRoot = newVal
    }
    func chooseNewSize(mustBeDifferent: Bool) {
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
    func clampChosenIntToAllowedSize() {
        if !(1 ... self.glop.maxSizeToRandomize).contains(chosenIntervalSize) {
            chooseNewSize(mustBeDifferent: false)
        }
        if !(Self.i1.minNote ... Self.i1.maxIntervalRoot(for: chosenIntervalSize)).contains(chosenRoot) {
            chooseNewRoot()
        }
    } //func
    func playNow(root: Int, interval: Int) -> Void {
        let i = NoteInterval(rootNote: root, size: interval)
        _ = Self.i1.playInterval(i, with: 0.75)
    }
    var body: some View {
        VStack {
            Text("score \(correctGuesses) / \(totalGuesses)")
            HStack {
                Button("new root") {
                    chooseNewRoot()
                } //btn
                .padding()
                Button("new interval") {
                    resetGuessingState()
                    chooseNewSize( mustBeDifferent: glop.newIntervalMustBeDifferent)
                    playFocused = true
                } //btn
                .padding()
            } //hs
            HStack {
                Button("  ") {
                    if glop.randomizeRootEachPlay {
                        chooseNewRoot()
                    }
                    clampChosenIntToAllowedSize()
                    playNow(root: chosenRoot, interval: chosenIntervalSize)
                } //btn
                .padding()
                .accessibilityFocused($playFocused)
                if glop.randomizeRootEachPlay {
                    Button("again") {
                        playNow(root: chosenRoot, interval: chosenIntervalSize)
                    } //btn
                } //if
            } //hs
            Button(btnTitle) {
                guard isGuessingState else {
                    resetGuessingState()
                    chooseNewSize( mustBeDifferent: glop.newIntervalMustBeDifferent)
                    playFocused = true
                    return
                } //gua
                guess(interval: 0)
            } //btn
            .accessibilityFocused($correctFocused)
            Divider()
            VStack {
                ForEach(0..<4) {row in
                    HStack {
                        ForEach(0..<3) {col in
                            Button {
                                let semitones = 1 + 3 * row + col
                                guard isGuessingState else {
                                    let newRoot = glop.randomizeRootEachPlay
                                    ? Int.random(in: Self.i1.minNote ... Self.i1.maxIntervalRoot(for: semitones))
                                    : chosenRoot
                                    playNow(root: newRoot, interval: semitones)
                                    return
                                } //gua
                                guess(interval: semitones)
                                correctFocused = true
                            } label: {
                                VStack {
                                    Text( isGuessingState
                                          ? "\( 1 + row * 3 + col )"
                                          : ("🎧 \( 1 + row * 3 + col )") )
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                } //vs
                                    .accessibilityElement(children: .combine)
                            } //btn
                            //.padding()
                        } //fe
                    } //hs
                } //fe
            } //vs
            Button(self.showingOptions ? "hide options" : "show options") {
                self.showingOptions.toggle()
            }
            if showingOptions {
                VStack {
                    Toggle("randomize root each play", isOn: $glop.randomizeRootEachPlay)
                    Toggle("change root when changing interval", isOn: $glop.changeRootEveryIntervalChange)
                    Picker("max interval size", selection: $glop.maxSizeToRandomize) {
                        ForEach(2..<13, id: \.self) {
                            Text("\($0)")
                        } //fe
                    } //pk
                    Toggle("new interval must be different", isOn: $glop.newIntervalMustBeDifferent)
                } //vs
            } //if
        } //vs
        .font(.largeTitle)
        .padding()
    } //body
} //str
