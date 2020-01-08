# PitchSpellingModel

![Swift Version](https://img.shields.io/badge/Swift-5.1-orange.svg)
[![Build Status](https://travis-ci.com/bwetherfield/PitchSpellingModel.svg?branch=latest)](https://travis-ci.com/bwetherfield/PitchSpellingModel)
[Code Coverage](https://codecov.io/github/bwetherfield/PitchSpellingModel)

## Contents

### Encodings

[`Encodings`](https://github.com/bwetherfield/PitchSpellingModel/tree/latest/Sources/Encodings) implements mappings between models of music, music notation and my Pitch Spelling Model. Models of music and music notation drawn from the **dn-m** ecosystem (_cf._ [`Music`](https://github.com/dn-m/Music), [`NotationModel`](https://github.com/dn-m/NotationModel)), .

### NetworkStructures

[`NetworkStructures`](https://github.com/bwetherfield/PitchSpellingModel/tree/latest/Sources/NetworkStructures) implements all the network operations and algorithms needed for the performance of Pitch Spelling Algorithms in forward and inverse directions.

### SpellingNetworks

[`SpellingNetworks`](https://github.com/bwetherfield/PitchSpellingModel/tree/latest/Sources/SpellingNetworks) specializes the **Encodings** and **NetworkStructures** modules to the use cases of the Pitch Spelling model.

## Workflow Sketch

First, make an `InvertingSpellingNetwork` (inputs can be `spellings: [Pitch]`, `spellings: [Int: Pitch]` or `spellings:[[Pitch]]`, where the last definition splits spellings easily into groups.
```swift
InvertingSpellingNetwork(spellings: [
            1: Pitch.Spelling(.f,.sharp),
            2: Pitch.Spelling(.a,.sharp),
            
            ...
            
            ])
```

Second, generate a `PitchSpellingNetworkFactory`. `sets` parameter forces arrays of `PitchedEdge` values to be equal in the inverting process (stabilization). A `preset` parameter can also be used to fix certain `PitchedEdge` weights in the process.

```swift
let factory = invertingSpellingNetwork.pitchSpellingNetworkFactory(
sets: [
            [
                PitchedEdge(.source, .internal(.init(1, .down))),
                PitchedEdge(.source, .internal(.init(6, .down))),
                PitchedEdge(.internal(.init(3, .up)), .sink),
                PitchedEdge(.internal(.init(10, .up)), .sink),
            ],

...
        ]
        )
```

Third, generate a `PitchSpellingNetwork` from the factory. `withPhantomPitches` feeds in pitches that will not be adjusted by the user, but will affect the spelling. The phantom pitches will always take their default spelling - hence `[0,4]` is acting as `[Pitch.Spelling(.c), Pitch.Spelling(.e)]`
```swift
let pitchSpellingNetwork = factory.build(from: [6,10,1], withPhantomPitches: [0,4])
```

Fourth, adjust `PitchSpellingNetwork` weights using mask schemes. Using the following mask function.
```swift
    // Adjusts edge weights based on an external scaling rule
    func mask <T> (scheme: FlowNetworkScheme<T>, _ lens: @escaping (Int) -> T)
```
`scheme` defines some weight scale factors based on `Edge<T>` values. These are pulled back to the `PitchSpellingNetwork`'s weight scheme via the `lens: @escaping (Int) -> T` parameter, which gives us a map from the pitch index `Int` to the index of the newly supplied `FlowNetworkScheme`. 

Fifth, spell! `preferring` is an optional parameter `.sharps` by default. It determines whether the search to determine the minimum cut found by the Edmonds-Karp maximum flow algorithm is taken from the `.source` or the `.sink`.
```swift
let spellings: [Int: SpelledPitch] = pitchSpellingNetwork.spell(preferring: .flats)
```

