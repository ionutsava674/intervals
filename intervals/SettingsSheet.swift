//
//  SettingsSheet.swift
//  intervals
//
//  Created by Ionut Sava on 23.01.2023.
//

import SwiftUI

struct SettingsSheet: View {
    //@Environment(\.presentationMode) private var premo
    @Environment(\.dismiss) private var dismiss
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
        ScrollView([.vertical], showsIndicators: true) {
            VStack(spacing: 20) {
                Button {
                    //premo.wrappedValue.dismiss()
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.title.bold())
                        .padding()
                } //btn
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                    Toggle("new interval must be different", isOn: $glop.newIntervalMustBeDifferent)
                        .padding(.horizontal)
                    Text("Every new interval that is generated, will always be different than the last one.")
                    Divider()
                    Toggle("change root when changing interval", isOn: $glop.changeRootEveryIntervalChange)
                        .padding(.horizontal)
                    Text("Every new interval will start with a different note.")
                    Divider()
                    Toggle("randomize root each time the interval is played", isOn: $glop.randomizeRootEachPlay)
                        .padding(.horizontal)
                    Text("Each time the Play button is pressed, the same interval will be played but starting from a different note.")
                    Divider()
                    } //gr

                    Group {
                    HStack {
                        Text("max interval size")
                            .accessibilityHidden(true)
                        Picker("max interval size", selection: $glop.maxSizeToRandomize) {
                            ForEach(2..<13, id: \.self) {
                                Text("\($0) semitones")
                            } //fe
                        } //pk
                        .padding(.horizontal)
                        .labelStyle(.iconOnly)
                    } //hs
                    Text("The maximum number of semitones when giving new intervals.")
                    Divider()
                        Toggle("Only allow ascending intervals", isOn: $glop.onlyAscending)
                        Text("If you want to get only ascending intervals, or both ascending and descending.")
                        Divider()
                    HStack {
                        Text("interval time")
                            .accessibilityHidden(true)
                        Picker("interval time", selection: $glop.intervalTimeSelection) {
                            ForEach(GlobalPreferences2.availableIntervalTimes.indices, id: \.self) {
                                let val = GlobalPreferences2.availableIntervalTimes[$0]
                                Text("\(val.toString(2)) s, \((60.0 / val).toString(2)) bpm")
                            } //fe
                        } //pk
                        .padding(.horizontal)
                        .labelsHidden()
                    } //hs
                        Text("The time duration between the notes played.")
                        Divider()
                    } //gr
                    HStack {
                        Text("Instrument")
                            .accessibilityHidden(true)
                        Picker(selection: $glop.selectedInstrumentName) {
                            ForEach(instrumentsSortedKeys, id: \.self) {
                                Text(GlobalPreferences2.availableInstruments[$0]?.name ?? "")
                            } //fe
                        } label: {
                            Text("Instrument")
                        } //pk
                        //.pickerStyle(.menu)
                        .padding(.horizontal)
                    } //hs
                    Divider()
                    Group {
                        Text(" Verbosity:")
                            .font(.title)
                            .accessibility(addTraits: AccessibilityTraits.isHeader)
                        Toggle("Use shorter texts and captions", isOn: $glop.shorterTexts)
                        Text("For advanced players, navigation speed is greatly improved.")
                        Divider()
                    } //gr
                    Button("Restore defaults") {
                        glop.restoreDefaults()
                    } //btn
                    .disabled( glop.valuesAreDefaults())
                } //vs 10
                //Spacer()
                Button {
                    //premo.wrappedValue.dismiss()
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.title.bold())
                        .padding()
                } //btn
            } //vs 20
        } //sv
        .frame(maxWidth: 500)
        //.accessibilityLabel("Settings")
    } //body
} //str
