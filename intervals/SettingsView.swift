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
                withAnimation {
                    self.showingOptions.toggle()
                } //wa
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
                    Picker("interval time", selection: $glop.intervalTime) {
                        ForEach(GlobalPreferences2.availableIntervalTimes, id: \.self) {
                            Text(String.init(format: "%.2g s, %.2g bpm", $0, 60 / $0))
                        } //fe
                    } //pk
                    Picker("instrument", selection: $glop.selectedInstrumentName) {
                        ForEach(GlobalPreferences2.availableInstruments.keys.filter({ k in
                            true
                        }), id: \.self) {
                            Text(GlobalPreferences2.availableInstruments[$0]?.name ?? "")
                        } //fe
                    } //pk
                } //vs
            } //if
        } //vs
    } //body
} //str
