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

    var body: some View {
        VStack(spacing: 20) {
            Text( gameData.success ? "Success" : "Game Over")
                .font(.largeTitle.bold())
            Divider()
            Text("Initial score \( gameData.initialQuestions.correctlyAnswered.count ) / \( gameData.initialQuestions.count )")
            Text("Initial duration: ") + Text(timerInterval: gameData.startTime ... (gameData.endTime ?? Date.now), pauseTime: nil, countsDown: false, showsHours: true)
            Text("\( gameData.questionList.count ) remaining wrong answers.")
            if let finTime = gameData.finalEndTime {
                Text("Total duration: ") + Text(timerInterval: gameData.startTime ... finTime, pauseTime: nil, countsDown: false, showsHours: true)
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
    } //body
} //str
