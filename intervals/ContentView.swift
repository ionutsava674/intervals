//
//  ContentView.swift
//  intervals
//
//  Created by Ionut on 12.12.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var currentGame: GameData? = nil
    @State private var showingGame = false
    var body: some View {
        //GameViewV1()
        GameViewV2(gameData:  GameData(questionTarget: 3) )
    } //body
} //str

