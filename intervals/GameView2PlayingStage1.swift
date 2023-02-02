//
//  GameView2PlayingStage1.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameView2PlayingStage1: View {
    @ObservedObject private var glop = GlobalPreferences2.global
    @ObservedObject var gameData: GameData
    @Binding var keepAlive: Bool
    
    @AccessibilityFocusState private var playFocused: Bool
    @AccessibilityFocusState private var correctFocused: Bool

    var correctBtnTitle: String {
        guard !gameData.isGuessingState else {
            return "guess the interval"
        } //gua
        return gameData.currentGuess == gameData.chosenIntervalSize
        ? "correct (\(gameData.chosenIntervalSize))"
        : "wrong (\(gameData.chosenIntervalSize))"
    } //cv
    var body: some View {
        VStack {
            Text("score \( gameData.correctGuessCounter ) / \( gameData.questionCounter )")
            HStack {
                Button {
                    gameData.actionPlayChosen()
                } label: {
                    Image(systemName: "play.circle.fill")
                        .padding()
                        .accessibilityLabel("  ")
                        .accessibilityValue("  ")
                } //btn
                //.accessibilityElement(children: .ignore)
                .accessibilityLabel("  ")
                .accessibilityValue("  ")
                .padding()
                .accessibilityFocused($playFocused)
            } //hs
            Button(correctBtnTitle) {
                guard gameData.isGuessingState else {
                    gameData.actionAcknowledgeAndReset()
                    playFocused = true
                    return
                } //gua
                //guess(interval: 0)
            } //btn
            .accessibilityFocused($correctFocused)
            .disabled(gameData.isGuessingState)
            Divider()
            VStack {
                ForEach(0..<4) {row in
                    HStack {
                        ForEach(0..<3) {col in
                            Button { //keypad button
                                let semitones = 1 + 3 * row + col
                                guard gameData.isGuessingState else {
                                    let newRoot = glop.randomizeRootEachPlay
                                    ? Int.random(in: gameData.selectedInstrument.minNote ... gameData.selectedInstrument.maxIntervalRoot(for: semitones))
                                    : gameData.chosenRoot
                                    gameData.playNow( root: newRoot, interval: semitones)
                                    return
                                } //gua
                                gameData.actionGuess( interval: semitones)
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
            if gameData.questionTarget == 0 {
                Button {
                    gameData.fromPlayingToSummary()
                } label: {
                    Text("Finish game")
                        .padding()
                } //btn
            } //if
        } //vs
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self.playFocused = true
            }
        } //app
    } //body
} //str
