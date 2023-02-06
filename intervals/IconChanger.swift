//
//  IconChanger.swift
//  intervals
//
//  Created by Ionut Sava on 06.02.2023.
//

import Foundation
import SwiftUI

class IconChanger: ObservableObject {
    @Published private(set) var currentIcon: AltAppIcon

    init() {
        if let iconName = UIApplication.shared.alternateIconName,
           let appIcon = AltAppIcon(rawValue: iconName) {
               currentIcon = appIcon
           } //ifl
        else {
            currentIcon = .primary
        } //els
    } //init
    @MainActor func changeAppIcon(to icon: AltAppIcon) async -> Bool {
        guard UIApplication.shared.alternateIconName != icon.iconName else {
            return true
        } //gua
        do {
            try await UIApplication.shared.setAlternateIconName( icon.iconName)
            currentIcon = icon
        } catch {
            return false
        }
        return true
    } //func
    enum AltAppIcon: String, CaseIterable, Identifiable {
        case primary = "AppIcon"
        case AltIcon1, AltIcon2, AltIcon3

        var id: String { rawValue }
        var iconName: String? {
            (self == .primary) ? nil : rawValue
        } //cv
    } //enum

} //cl

struct IconChangeView: View {
    @StateObject var ic = IconChanger()
    var body: some View {
        VStack(spacing: 8) {
            ForEach(IconChanger.AltAppIcon.allCases) { icon in
                Button(icon.iconName ?? "default") {
                    Task {
                        await ic.changeAppIcon(to: icon)
                    }
                }
            } //fe
        } //hs
    } //body
} //str
