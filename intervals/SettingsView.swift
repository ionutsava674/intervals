//
//  SettingsView.swift
//  intervals
//
//  Created by Ionut on 18.12.2022.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingOptions = false
    @ObservedObject private var glop = GlobalPreferences2.global
    var body: some View {
        VStack {
            Button(self.showingOptions ? "hide options" : "show options") {
                self.showingOptions.toggle()
            }
            if showingOptions {
                VStack {
                    Toggle("randomize root each play", isOn: $glop.randomizeRootEachPlay)
                    Toggle("change root when changing interval", isOn: $glop.changeRootEveryIntervalChange)
                    Picker("max interval size", selection: $glop.maxSizeToRandomize) {
                        ForEach(2..<13, id: \.self) {
                            Text("\($0)")
                        } //fe
                    } //pk
                    Toggle("new interval must be different", isOn: $glop.newIntervalMustBeDifferent)
                } //vs
            } //if
        } //vs
    } //body
} //str
