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
    
    func build (from pitches: [Int: Pitch], withPhantomPitches phantomPitches: [Int: Pitch] = [:]) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: phantomPitches)
    }
    
    func build (from pitches: [[Pitch]], withPhantomPitches phantomPitches: [Int: Pitch] = [:]) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: phantomPitches)
    }
    
    func build (from pitches: [Pitch], withPhantomPitches phantomPitches: [Int: Pitch] = [:]) -> PitchSpellingNetwork {
        return PitchSpellingNetwork(pitches: pitches, weightScheme: weightScheme, phantomPitches: phantomPitches)
    }
}
