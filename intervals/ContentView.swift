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
    @State private var showingAcc = false
    @State private var showingSettings = false
    var body: some View {
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
                .transition(.asymmetric(
                    insertion: .move( edge: .bottom),
                    removal: .move( edge: .trailing)))
        } else {
            VStack(spacing: 24) {
                Text("Begin new round:")
                    .font(.largeTitle.bold())
                Divider()
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
                        VStack(alignment: .leading, spacing: 16) {
                            Group {
                                Text("For VoiceOver users, we recommend that you create a custom activity for this app, in which the UI interraction sounds are turned off. ")
                                Text("So that when the sounds are played, system sounds are not overlapped.")
                                Divider()
                                Text("Steps to create custom activity:")
                                Text("• go to iOS settings")
                                Text("• Accessibility")
                                Text("• VoiceOver")
                                Text("• Activities")
                                Text("• Add Activity…")
                            } //gr
                            Group {
                                Text("• enter a name, the default may be \"Activity 1\"")
                                Text("• set \"Mute Sound\" from Default to On")
                                Text("Depending on your default settings, you may also want to turn off:")
                                Text("• Container Descriptions")
                                Text("• Speak Hints")
                                Text("• click Apps")
                                Text("• choose this app from the list")
                                Text("• click \"back\", there is no ok button here")
                                Text("• Then click \"Activities - back button\" again, on the top. There is no ok or save button.")
                            } //gr

                        } //vs
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

