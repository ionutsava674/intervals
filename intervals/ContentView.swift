//
//  ContentView.swift
//  intervals
//
//  Created by Ionut on 12.12.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var glop = GlobalPreferences2.global
    @State private var currentGame: GameData = GameData(questionTarget: 0, instrumentName: GlobalPreferences2.global.selectedInstrumentName)
    @State private var showingGame = false
    var body: some View {
        //GameViewV1()
        //GameViewV2(gameData:  GameData(questionTarget: 3) )
        if showingGame {
            GameViewV2(gameData:  self.currentGame, keepAlive: $showingGame )
            /*
            Button("close") {
                withAnimation(.easeIn(duration: 4)) {
                    showingGame = false
                } //wa
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
             */
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .trailing)))
        } else {
            VStack(spacing: 12) {
                Button("20 intervals") {
                    currentGame = GameData(questionTarget: 20, instrumentName: glop.selectedInstrumentName)
                    withAnimation {
                        showingGame = true
                    } //wa
                } //btn
                Button("50 intervals") {
                    currentGame = GameData(questionTarget: 50, instrumentName: glop.selectedInstrumentName)
                    withAnimation {
                        showingGame = true
                    } //wa
                } //btn
                Button("100 intervals") {
                    currentGame = GameData(questionTarget: 100, instrumentName: glop.selectedInstrumentName)
                    withAnimation {
                        showingGame = true
                    } //wa
                } //btn
                Button("no limit game") {
                    currentGame = GameData(questionTarget: 0, instrumentName: glop.selectedInstrumentName)
                    withAnimation {
                        showingGame = true
                    } //wa
                } //btn
                SettingsView()
            } //vs
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(.red)
            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .trailing)))
        } //ife
    } //body
} //str

