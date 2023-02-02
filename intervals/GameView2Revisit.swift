//
//  GameView2Revisit.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameView2Revisit: View {
    @ObservedObject private var glop = GlobalPreferences2.global
    @ObservedObject var gameData: GameData
    @Binding var keepAlive: Bool
    
    @AccessibilityFocusState private var playFocused: Bool
    @AccessibilityFocusState private var correctFocused: Bool

    var correctBtnTitle: String {
        guard !gameData.isGuessingState else {
            return "guess the interval"
        } //gua
        guard let ci = gameData.revisitationCurrentInterval else {
            return "error"
        }
        return gameData.currentGuess == ci.size
        ? "correct (\(ci.size))"
        : "wrong (\(ci.size))"
    } //cv
    var body: some View {
        VStack {
            Gauge(value: Float( ( gameData.isGuessingState ? 0 : 1 ) + (gameData.revisitationCurrentIndex ?? 0)), in: 0.0 ... Float(gameData.revisitationQuestions.count)) {
                Text("question \(1 + (gameData.revisitationCurrentIndex ?? -1)) of \( gameData.revisitationQuestions.count )")
            } //ga
            Button("  ") {
                gameData.actionPlayCurrentRevisitation()
            } //btn
            .padding()
            .accessibilityFocused($playFocused)
            Button(correctBtnTitle) {
                guard gameData.isGuessingState else {
                    gameData.actionAcknowledgeRevisitation()
                    playFocused = true
                    return
                } //gua
            } //btn
            .accessibilityFocused($correctFocused)
            .disabled(gameData.isGuessingState)
            Divider()
            VStack {
                ForEach(0..<4) {row in
                    HStack {
                        ForEach(0..<3) {col in
                            Button { // pad
                                let semitones = 1 + 3 * row + col
                                guard gameData.isGuessingState else {
                                    guard let newReNote = gameData.revisitationCurrentInterval else {
                                        return
                                    } //gua2
                                    let newRoot = glop.randomizeRootEachPlay
                                    ? Int.random(in: gameData.selectedInstrument.minNote ... gameData.selectedInstrument.maxIntervalRoot(for: semitones))
                                    : newReNote.rootNote
                                    gameData.playNow( root: newRoot, interval: semitones)
                                    return
                                } //gua 1
                                gameData.actionReGuess( interval: semitones)
                                correctFocused = true
                            } label: {
                                VStack {
                                    Text( gameData.isGuessingState
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
        } //vs
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self.playFocused = true
            }
        } //app
    } //body
} //str
