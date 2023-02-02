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
    var instrumentsSortedKeys: [String] {
        GlobalPreferences2.availableInstruments.keys
            .filter({ k in
            true
        }).sorted(by: {
            GlobalPreferences2.availableInstruments[$0]?.name ?? "" < GlobalPreferences2.availableInstruments[$1]?.name ?? ""
        })
    } //cv
    var body: some View {
        VStack {
            Button(self.showingOptions ? "hide options" : "show options") {
                withAnimation {
                    self.showingOptions.toggle()
                } //wa
            }
            if showingOptions {
                VStack {
                    Form {
                        Toggle("new interval must be different", isOn: $glop.newIntervalMustBeDifferent)
                            .padding(.horizontal)
                        Toggle("change root when changing interval", isOn: $glop.changeRootEveryIntervalChange)
                            .padding(.horizontal)
                        Toggle("randomize root each time the interval is played", isOn: $glop.randomizeRootEachPlay)
                            .padding(.horizontal)

                        Picker("max interval size", selection: $glop.maxSizeToRandomize) {
                            ForEach(2..<13, id: \.self) {
                                Text("\($0) semitones")
                            } //fe
                        } //pk
                        .padding(.horizontal)

                        /*
                        Picker("interval time", selection: $glop.intervalTime) {
                            ForEach(GlobalPreferences2.availableIntervalTimes, id: \.self) {
                                Text("\($0.toString(2)) s, \((60.0 / $0).toString(2)) bpm")
                            } //fe
                        } //pk
                        .padding(.horizontal)
                         */

                        Picker(selection: $glop.selectedInstrumentName) {
                            ForEach(instrumentsSortedKeys, id: \.self) {
                                Text(GlobalPreferences2.availableInstruments[$0]?.name ?? "")
                            } //fe
                        } label: {
                            Text("Instrument")
                        } //pk
                        .padding(.horizontal)
                    } //form
                } //vs
            } //if
        } //vs
    } //body
} //str

extension Double {
    func toString(_ maxDecimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxDecimals
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .decimal

        return formatter.string(from: self as NSNumber) ?? "n/a"
    } //func
} //ext
