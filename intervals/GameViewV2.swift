//
//  GameViewV2.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameViewV3: View {
    @ObservedObject var gameData: GameDataV3
    @Binding var keepAlive: Bool

    var body: some View {
        VStack {
            switch gameData.gameState {
            case .playing:
                GameView3PlayingStage1(gameData: gameData, keepAlive: $keepAlive)
            case .summary:
                GameView3Summary( gameData: gameData, keepAlive: $keepAlive)
                //EmptyView()
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
