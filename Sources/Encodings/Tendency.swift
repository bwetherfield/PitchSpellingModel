//
//  Tendency.swift
//  PitchSpeller
//
//  Created by James Bean on 5/22/18.
//

import DataStructures
import Pitch
import SpelledPitch

public typealias TendencyPair = OrderedPair<Tendency>

/// One of two values encoded in a Wetherfield `FlowNetwork`. Each provides a tendency `up`, or
/// `down` for the purposes of spelling an unspelled pitch in a given musical context.
public enum Tendency: Int {
    case down = 0
    case up = 1
}

extension Tendency: Codable { }

extension Pitch.Spelling {

    /// Creates a `Pitch.Spelling` value with the given `pitchClass` and the given `tendencies`,
    /// which are resultant from the Wetherfield-encoded and -decoded `FlowNetwork`, if it is
    /// possible. Otherwise, returns `nil`.
    public init?(pitchClass: Pitch.Class, tendencies: TendencyPair) {
        guard
            let category = Pitch.Spelling.Category[pitchClass],
            let modifierDirection = category.modifierDirection(for: tendencies)
        else {
            return nil
        }
        self.init(pitchClass: pitchClass, modifierDirection: modifierDirection)
    }
}
