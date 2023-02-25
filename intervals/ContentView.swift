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
            VStack(alignment: .center, spacing: 30) {
                HStack(alignment: .center, spacing: 8) {
                    Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                        .resizable()
                        .frame(width: 48, height: 48, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    Text("Welcome to Intervals")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.leading)
                        //.lin
                } //hs
                Divider()
                VStack(spacing: 18) {
                    //IconChangeView()
                    Text("Begin a new round of:")
                        .font(.title.bold())
                    Button("20 intervals") {
                        currentGame = GameDataV3(questionTargetCount: 20, instrumentName: glop.selectedInstrumentName)
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
                } //vs 18
                Button("Show settings") {
                    self.showingSettings = true
                } //btn
                if UIAccessibility.isVoiceOverRunning {
                    Button("Accessibility") {
                        self.showingAcc = true
                    } //btn
                    .sheet(isPresented: $showingAcc) {
                        AccessActi()
                    } //sheet
                } //if ax
            } //vs30
                .sheet(isPresented: $showingSettings) {
                    SettingsSheet()
                } //sheet
            .font(.title.bold())
            .transition(.asymmetric(
                insertion: .move( edge: .bottom),
                removal: .move( edge: .trailing)))
        } //ife
    } //body
} //str

