//
//  Instrument.swift
//  intervals
//
//  Created by Ionut on 13.12.2022.
//

import Foundation

enum MuzicalNote{
    static let basicNames: [String] = [ "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" ]
    static func getName(from midiValue: Int) -> String {
        guard (0 ... 127).contains(midiValue) else {
            return ""
        } //gua
        let octave = Int(midiValue / 12) - 1
        let semiTone = midiValue % 12
        return "\( Self.basicNames[semiTone] )\( octave )"
    } //func
} //cl
struct NoteInterval: Hashable {
    let rootNote: Int
    let size: Int
} //str

class Instrument {
    let name: String
    let minNote: Int
    let maxNote: Int
    var soundBank: [Int: GameSound?]
    
    init(name: String = "", minNote: Int = 0, maxNote: Int = 127) {
        self.name = name
        self.minNote = Swift.max(0, minNote)
        self.maxNote = Swift.max(self.minNote, Swift.min(127, maxNote))
        self.soundBank = [:]
        
        for note in self.minNote ... self.maxNote {
            soundBank[note] = try? GameSound(soundFile: "sfx2/" + getSoundName(from: note), maxNrOfPlayers: 3)
        }
    } //init
    func playInterval(_ interval: NoteInterval, with delay: Double) -> Bool {
        guard (minNote ... maxIntervalRoot(for: interval.size)).contains(interval.rootNote) else {
            return false
        } //gua
        //self.soundBank[interval.rootNote]??.prepareAndPlay()
        let ga = GroupedAsync()
        ga.asyncInMain(deadline: .now()) {
            self.soundBank[interval.rootNote]??.prepareAndPlay()
        }
        ga.asyncInMain(deadline: .now() + delay) {
            self.soundBank[interval.rootNote + interval.size]??.prepareAndPlay()
        }
        return true
    } //func
    func maxIntervalRoot(for intervalSize: Int) -> Int {
        maxNote - intervalSize
    } //func
    private func getSoundName(from midiValue: Int) -> String {
        let auxInst = name.isEmpty ? "" : (name + " ")
        return "\( auxInst )\( midiValue ) \( MuzicalNote.getName(from: midiValue) ).wav"
    } //func
} //cl

