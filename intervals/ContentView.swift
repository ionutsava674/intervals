//
//  ContentView.swift
//  intervals
//
//  Created by Ionut on 12.12.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var currentGame: GameData = GameData(questionTarget: 0)
    @State private var showingGame = false
    var body: some View {
        //GameViewV1()
        //GameViewV2(gameData:  GameData(questionTarget: 3) )
        if showingGame {
            GameViewV2(gameData:  self.currentGame )
        } else {
            VStack {
                Button("20 intervals") {
                    currentGame = GameData(questionTarget: 20)
                    showingGame = true
                } //btn
                SettingsView()
            } //vs
        } //ife
    } //body
} //str

