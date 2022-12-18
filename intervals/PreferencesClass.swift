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

    static let global = GlobalPreferences2()
    
    func restoreDefaults() -> Void {
        maxSizeToRandomize = 4
        randomizeRootEachPlay = false
        changeRootEveryIntervalChange = false
        newIntervalMustBeDifferent = true
    } //func
} //class
