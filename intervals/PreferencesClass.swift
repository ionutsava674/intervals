//
//  PreferencesClass.swift
//  Tab Extractor
//
//  Created by Ionut on 25.06.2021.
//

import Foundation
import SwiftUI

class GlobalPreferences2: ObservableObject {
    @AppStorage("maxSizeToRandomize") var maxSizeToRandomize = 4
    @AppStorage("randomizeRootEachPlay") var randomizeRootEachPlay = false
    @AppStorage("changeRootEveryIntervalChange") var changeRootEveryIntervalChange = false
    @AppStorage("newIntervalMustBeDifferent") var newIntervalMustBeDifferent = true
    @AppStorage("intervalTimeSelection") var intervalTimeSelection: Int = 0
    var getIntervalTime: Double {
        Self.availableIntervalTimes[ intervalTimeSelection]
    } //cv
    static let availableIntervalTimes: [Double] = [60 / 45, 1.0, 60 / 70, 60 / 80, 60 / 90, 60 / 120, 60 / 180]
    @AppStorage("selectedInstrumentName") var selectedInstrumentName = ""
    static let availableInstruments: [String: (name: String, minNote: Int, maxNote: Int)] = [
        "": ("piano, medium", 45, 72),
        "long": ("piano, long", 45, 72),
        "veryShort": ("synth, very short", 52, 76),
        "syn37": ("synth, short", 45, 72),
        "short": ("synth, medium", 45, 72),
    ]

    static let global = GlobalPreferences2()
    
    func restoreDefaults() -> Void {
        maxSizeToRandomize = 4
        randomizeRootEachPlay = false
        changeRootEveryIntervalChange = false
        newIntervalMustBeDifferent = true
        intervalTimeSelection = 0
        selectedInstrumentName = ""
    } //func
    func valuesAreDefaults() -> Bool {
        maxSizeToRandomize == 4
        && randomizeRootEachPlay == false
        && changeRootEveryIntervalChange == false
        && newIntervalMustBeDifferent == true
        && intervalTimeSelection == 0
        && selectedInstrumentName == ""
        //&& intervalTime == 0.6666
    } //func
} //class
