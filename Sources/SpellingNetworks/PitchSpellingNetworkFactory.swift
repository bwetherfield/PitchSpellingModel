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

class PitchSpellingNetworkFactory {
    
    let weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>
    
    init (_ weightScheme: FlowNetworkScheme<Cross<Pitch.Class, Tendency>>) {
        self.weightScheme = weightScheme
    }
    
    func build (from pitches: [Int: Pitch], withPhantomPitches phantomPitches: [Pitch] = []) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: index(phantomPitches))
    }
    
    func build (from pitches: [[Pitch]], withPhantomPitches phantomPitches: [Pitch] = []) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: index(phantomPitches))
    }
    
    func build (from pitches: [Pitch], withPhantomPitches phantomPitches: [Pitch] = []) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: index(phantomPitches))
    }
    
    func index(_ pitches: [Pitch]) -> [Int: Pitch] {
        let indexed: [Int: Pitch] = pitches.enumerated().reduce(into: [:]) { indexedPitches, indexedPitch in
            let (index, pitch) = indexedPitch
            indexedPitches[index] = pitch
        }
        return indexed
    }
}
