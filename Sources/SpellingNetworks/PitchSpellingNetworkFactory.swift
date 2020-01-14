//
//  PitchSpellingNetworkFactory.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 12/30/19.
//

import Pitch
import DataStructures
import NetworkStructures
import Encodings

/// Stores `weightScheme` for creating `PitchSpellingNetwork` instance from `pitches` and `phantomPitches` of
/// varying types
class PitchSpellingNetworkFactory {
    
    // MARK: - Instance Properties
    
    let weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>
    
    // MARK: - Initializers
    
    init (_ weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>) {
        self.weightScheme = weightScheme
    }
    
    // MARK: - Instance Methods

    func build (from pitches: [Int: Pitch], withPhantomPitches phantomPitches: [Pitch] = []) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: index(phantomPitches))
    }
    
    func build (from pitches: [[Pitch]], withPhantomPitches phantomPitches: [Pitch] = []) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: index(phantomPitches))
    }
    
    func build (from pitches: [Pitch], withPhantomPitches phantomPitches: [Pitch] = []) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: index(phantomPitches))
    }
    
    /// - Returns: Indexed dictionary from array of `Pitch` values
    // TODO: make generic function
    func index(_ pitches: [Pitch]) -> [Int: Pitch] {
        let indexed: [Int: Pitch] = pitches.enumerated().reduce(into: [:]) { indexedPitches, indexedPitch in
            let (index, pitch) = indexedPitch
            indexedPitches[index] = pitch
        }
        return indexed
    }
}
