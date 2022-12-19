//
//  GameViewV2.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameViewV2: View {
    @ObservedObject var gameData: GameData
    @Binding var keepAlive: Bool
    var body: some View {
        VStack {
            switch gameData.gameState {
            case .playing:
                GameView2PlayingStage1(gameData: gameData, keepAlive: $keepAlive)
            case .summary:
                GameView2Summary(gameData: gameData, keepAlive: $keepAlive)
            case .revisiting:
                GameView2Revisit(gameData: gameData, keepAlive: $keepAlive)
            } //swi
            Button("Close game") {
                withAnimation {
                    keepAlive = false
                } //wa
            } //btn
            .padding()
        } //vs
    } //body
} //str
