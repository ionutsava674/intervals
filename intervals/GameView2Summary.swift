//
//  GameView2Summary.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameView2Summary: View {
    @ObservedObject var gameData: GameData
    var body: some View {
        VStack(spacing: 10) {
            Text("Initial score \( gameData.correctGuessCounter ) / \( gameData.questionCounter ), \( gameData.totalDistinctQuestions ) distinct intervals")
            Text("Initial duration: ") + Text(timerInterval: gameData.startTime ... (gameData.endTime ?? Date.now), pauseTime: nil, countsDown: false, showsHours: true)
            Text("\( gameData.wrongDistinctGuesses ) remaining wrong answers.")
            if let finTime = gameData.finalEndTime {
                Text("Total duration: ") + Text(timerInterval: gameData.startTime ... finTime, pauseTime: nil, countsDown: false, showsHours: true)
            } //if
            Divider()
            if gameData.canRevisit() {
                Button {
                    gameData.actionEnterRevisitation()
                } label: {
                    Text("Go over the wrong answers again")
                } //btn
            } //if
        } //vs
    } //body
} //str
