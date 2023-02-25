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

struct NoteIntervalV3: Hashable {
    let rootNote: Int
    let size: Int
    var getAbsSize: Int { Swift.abs(size) } //cv
    var isAscending: Bool { size > 0 }
    var secondNote: Int { rootNote + size }
    var minNote: Int { Swift.min(rootNote, secondNote) }
    var maxNote: Int { Swift.max(rootNote, secondNote) }
} //str

class InstrumentV3 {
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
    func canPlayInterval(_ interval: NoteIntervalV3) -> Bool {
        (minNote ... maxNote).contains( interval.minNote)
        && (minNote ... maxNote).contains( interval.maxNote)
    } //func
        func playInterval(_ interval: NoteIntervalV3, with delay: Double) -> Bool {
        guard canPlayInterval( interval) else {
            return false
        } //gua
        let ga = GroupedAsync()
        ga.asyncInMain(deadline: .now()) {
            self.soundBank[interval.rootNote]??.prepareAndPlay()
        }
        ga.asyncInMain(deadline: .now() + delay) {
            self.soundBank[interval.secondNote]??.prepareAndPlay()
        }
        return true
    } //func
    func maxIntervalRoot(for intervalSize: Int) -> Int {
        Swift.min(maxNote - intervalSize, maxNote)
    } //func
    func minIntervalRoot( for intervalSize: Int) -> Int {
        Swift.max(minNote - intervalSize, minNote)
    } //func
    private func getSoundName(from midiValue: Int) -> String {
        let auxInst = name.isEmpty ? "" : (name + " ")
        return "\( auxInst )\( midiValue ) \( MuzicalNote.getName(from: midiValue) ).wav"
    } //func
    func rootRangeForIntervalSizeRange(_ range: ClosedRange<Int>) -> ClosedRange<Int> {
        minIntervalRoot(for: range.lowerBound) ... maxIntervalRoot(for: range.upperBound)
    } //func
} //cl
////
