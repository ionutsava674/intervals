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
        VStack {
            Text("Score \( gameData.correctGuesses ) / \( gameData.totalGuesses )")
            Text("Duration: ") + Text(timerInterval: gameData.startTime ... (gameData.endTime ?? Date.now), pauseTime: nil, countsDown: false, showsHours: true)
            //Divider()
            if gameData.correctGuesses < gameData.totalGuesses {
                Button {
                    gameData.actionEnterRevisitation()
                } label: {
                    Text("Go over the wrong answers again")
                } //btn
            } //if
        } //vs
    } //body
} //str
