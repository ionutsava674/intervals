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
        //NavigationView {
        VStack(spacing: 20) {
            Button {
                //premo.wrappedValue.dismiss()
                dismiss()
            } label: {
                Text("Close")
                    .font(.title.bold())
                    .padding()
            } //btn
                    //Form {
            VStack(alignment: .leading, spacing: 10) {
                        Toggle("new interval must be different", isOn: $glop.newIntervalMustBeDifferent)
                            .padding(.horizontal)
                        Toggle("change root when changing interval", isOn: $glop.changeRootEveryIntervalChange)
                            .padding(.horizontal)
                        Toggle("randomize root each time the interval is played", isOn: $glop.randomizeRootEachPlay)
                            .padding(.horizontal)

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
                    .padding(.horizontal)
                } //hs
                Divider()
                        Button("Restore defaults") {
                            glop.restoreDefaults()
                        } //btn
                        .disabled( glop.valuesAreDefaults())
                    } //form vs
            Spacer()
        } //vs
        .frame(maxWidth: 500)
        //.accessibilityLabel("Settings")
    } //body
} //str
