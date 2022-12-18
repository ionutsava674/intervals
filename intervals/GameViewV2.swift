//
//  GameViewV2.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct GameViewV2: View {
    @ObservedObject var gameData: GameData
    var body: some View {
        switch gameData.gameState {
        case .playing:
            GameView2PlayingStage1(gameData: gameData)
        case .summary:
            GameView2Summary(gameData: gameData)
        case .revisiting:
            GameView2Revisit(gameData: gameData)
        } //swi
    } //body
} //str
