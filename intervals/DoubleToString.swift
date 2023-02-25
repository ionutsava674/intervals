//
//  DoubleToString.swift
//  intervals
//
//  Created by Ionut Sava on 24.02.2023.
//

import Foundation

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
