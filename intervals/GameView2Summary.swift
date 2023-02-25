//
//  GameView2Summary.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameView3Summary: View {
    @ObservedObject var gameData: GameDataV3
    @Binding var keepAlive: Bool

    @AccessibilityFocusState private var titleFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text( gameData.success ? "Success" : "Game Over")
                .font(.largeTitle.bold())
                .accessibilityFocused($titleFocused)
            Divider()
            Text("Initial score \( gameData.initialQuestions.correctlyAnswered.count ) / \( gameData.initialQuestions.count )")
            Text("Initial duration: ") + Text(timerInterval: gameData.startTime ... (gameData.endTimes.first ?? Date.now), pauseTime: nil, countsDown: false, showsHours: true)
            Divider()
            if gameData.revisitationCount > 0 {
                Text("Current score: \(gameData.completedQuestions.count) / \( gameData.completedQuestions.count + gameData.questionList.count )")
            }
            Text("\( gameData.questionList.count ) remaining wrong answers.")
            if gameData.revisitationCount > 0 {
                if let finTime = gameData.endTimes.last {
                    Text("Total duration: ") + Text(timerInterval: gameData.startTime ... finTime, pauseTime: nil, countsDown: false, showsHours: true)
                } //if
            } //if
            Divider()
            if gameData.canRevisit {
                Button {
                    gameData.actionRevisit()
                } label: {
                    Text("Go over the wrong answers again")
                } //btn
            } //if
        } //vs
        .font(.title)
        .axFocusAppear {
            self.titleFocused = true
        }
    } //body
} //str
