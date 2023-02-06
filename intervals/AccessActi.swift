//
//  AccessActi.swift
//  intervals
//
//  Created by Ionut Sava on 06.02.2023.
//

import SwiftUI

struct AccessActi: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            ScrollView([.vertical], showsIndicators: true) {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                //premo.wrappedValue.dismiss()
                dismiss()
            } label: {
                Text("Close")
                    .font(.title.bold())
                    .padding()
            } //btn
            .padding()
            Group {
                Text("For VoiceOver users, we recommend that you create a custom activity for this app, in which the UI interraction sounds are turned off. ")
                Text("So that when the notes are played, system sounds are not overlapped.")
                Divider()
                Text("Steps to create custom activity:")
                Text("• go to iOS settings")
                Text("• Accessibility")
                Text("• VoiceOver")
                Text("• Activities")
                Text("• Add Activity…")
            } //gr
            Group {
                Text("• enter a name, the default may be \"Activity 1\"")
                Text("• set \"Mute Sound\" from Default to On")
                Text("Depending on your default settings, you may also want to turn off:")
                Text("• Container Descriptions")
                Text("• Speak Hints")
                Text("• click Apps")
                Text("• choose this app from the list")
                Text("• click \"back\", there is no ok button here")
                Text("• Then click \"Activities - back button\" again, on the top. There is no ok or save button.")
            } //gr

        } //vs
            } //sv
        } //vs
    } //body
} //view

struct AccessActi_Previews: PreviewProvider {
    static var previews: some View {
        AccessActi()
    }
}
