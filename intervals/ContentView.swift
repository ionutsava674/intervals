//
//  ContentView.swift
//  intervals
//
//  Created by Ionut on 12.12.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var glop = GlobalPreferences2.global
    @State private var currentGame: GameDataV3 = GameDataV3(questionTargetCount: 0, instrumentName: GlobalPreferences2.global.selectedInstrumentName)

    @State private var showingGame = false
    @State private var showingAcc = false
    @State private var showingSettings = false
    var body: some View {
        if showingGame {
            GameViewV3(gameData:  self.currentGame, keepAlive: $showingGame )
            /*
            Button("close") {
                withAnimation(.easeIn(duration: 4)) {
                    showingGame = false
                } //wa
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
             */
                .transition(.asymmetric(
                    insertion: .move( edge: .bottom),
                    removal: .move( edge: .trailing)))
        } else {
            VStack(spacing: 24) {
                //IconChangeView()
                Text("Begin new round:")
                    .font(.largeTitle.bold())
                Divider()
                Button("20 intervals") {
                    currentGame = GameDataV3(questionTargetCount: 2, instrumentName: glop.selectedInstrumentName)
                    withAnimation {
                        showingGame = true
                    } //wa
                } //btn
                Button("50 intervals") {
                    currentGame = GameDataV3(questionTargetCount: 50, instrumentName: glop.selectedInstrumentName)
                    withAnimation {
                        showingGame = true
                    } //wa
                } //btn
                Button("100 intervals") {
                    currentGame = GameDataV3(questionTargetCount: 100, instrumentName: glop.selectedInstrumentName)
                    withAnimation {
                        showingGame = true
                    } //wa
                } //btn
                Button("no limit game") {
                    currentGame = GameDataV3(questionTargetCount: 0, instrumentName: glop.selectedInstrumentName)
                    withAnimation {
                        showingGame = true
                    } //wa
                } //btn
                //SettingsView()
                Divider()
                Button("Show settings") {
                    self.showingSettings = true
                } //btn
                .sheet(isPresented: $showingSettings) {
                    SettingsSheet()
                } //sheet
                if UIAccessibility.isVoiceOverRunning {
                    Button("Accessibility") {
                        self.showingAcc = true
                    } //btn
                    .sheet(isPresented: $showingAcc) {
                        AccessActi()
                    } //sheet
                } //if
            } //vs
            .font(.title.bold())
            .transition(.asymmetric(
                insertion: .move( edge: .bottom),
                removal: .move( edge: .trailing)))
        } //ife
    } //body
} //str

