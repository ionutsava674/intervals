//
//  GameView2PlayingStage1.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameView3PlayingStage1: View {
    @ObservedObject private var glop = GlobalPreferences2.global
    @ObservedObject var gameData: GameDataV3
    @Binding var keepAlive: Bool

    @AccessibilityFocusState private var playFocused: Bool
    @AccessibilityFocusState private var correctFocused: Bool

    var statusText1: String {
        if gameData.isGuessingState {
            return gameData.canGuessAnswer
            ? "how many semitones are in the interval?"
            : "Tap Play to hear the interval, then you can enter your answer"
        } else {
            return gameData.currentAnsweredCorrectly
            ? "correct - \(gameData.correctAnswer)"
            : "Wrong answer. The correct answer was \(gameData.correctAnswer)"
        } //else
    } //cv
    var body: some View {
        VStack {
            Text("Question \( gameData.currentQuestionIndex + 1 ) / \( gameData.questionList.count )")
            Text("Score \( gameData.correctlyAnsweredQuestions.count ) / \( gameData.answeredQuestions.count )")
                //.font(.title.bold())
            HStack {
Text("  ")
                    .accessibilityLabel(Text("The next item is the play button"))
                Button {
                    withAnimation {
                        gameData.actionPlay()
                    }
                } label: {
                    Image(systemName: gameData.isGuessingState ? "play.circle.fill" : "headphones")
                        .padding()
                        .accessibilityLabel("  ")
                        .accessibilityValue("  ")
                } //btn
                .accessibilityLabel("  ")
                .accessibilityValue("  ")
                .padding()
                .accessibilityFocused($playFocused)
                .accessibilityAddTraits(.playsSound)
                .accessibilityRemoveTraits(.isButton)
            } //hs
                Text(statusText1)
                .onTapGesture {
                    withAnimation {
                        gameData.actionNextQuestion()
                        playFocused = true
                    }
                } //tap
                .accessibilityFocused($correctFocused)
            if !gameData.isGuessingState {
                Button("Continue") {
                    withAnimation {
                        gameData.actionNextQuestion()
                        playFocused = true
                    }
                } //btn
                .font(.title)
                .disabled( gameData.isGuessingState)
                .padding()
                Text("You can now tap a number to listen and compare")
            } //if
            Divider()
            if gameData.canGuessAnswer {
                VStack {
                    Button { //keypad button
                        padTap(0)
                    } label: {
                        VStack {
                            Text( gameData.isGuessingState
                                  ? "0 (same note)"
                                  : "🎧 0 (same note)" )
                            .padButtonInnerText()
                        } //vs
                            .accessibilityElement(children: .combine)
                    } //btn
                    .padButtonStyle()
                    ForEach(0..<4) {row in
                        HStack {
                            ForEach(0..<3) {col in
                                Button { //keypad button
                                    let semitones = 1 + 3 * row + col
                                    padTap( semitones)
                                } label: {
                                    VStack {
                                        Text( gameData.isGuessingState
                                              ? "\( 1 + row * 3 + col )"
                                              : ("🎧 \( 1 + row * 3 + col )") )
                                        .padButtonInnerText()
                                    } //vs
                                        .accessibilityElement(children: .combine)
                                } //btn
                                .padButtonStyle()
                            } //fe
                        } //hs
                    } //fe
                } //vs
                .frame(maxWidth: 350)
                .transition(.move(edge: .bottom) )
            } //if
            /*
            if gameData.limi {
                Button {
                    gameData.fromPlayingToSummary()
                } label: {
                    Text("Finish game")
                        .padding()
                } //btn
            } //if
             */
        } //vs
        .font(.headline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                self.playFocused = true
            }
        } //app
    } //body
    func padTap(_ interval: Int) {
        if gameData.isGuessingState {
            gameData.actionGuess(interval)
            correctFocused = true
        } else {
            gameData.actionCustomPlay( interval)
        } //else
    } //func
} //str

extension View {
    func padButtonStyle() -> some View {
        self
            .accessibilityAddTraits(.playsSound)
            .accessibilityRemoveTraits(.isButton)
            .background( Color(uiColor: .secondarySystemBackground) )
            .clipShape( RoundedRectangle(cornerRadius: 8))
            .overlay(.gray, in: RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2))
            .padding(3)
    } //func
    func padButtonInnerText() -> some View {
        self
            .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
    } //func
} //ext
