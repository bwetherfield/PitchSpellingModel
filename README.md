# PitchSpellingModel

![Swift Version](https://img.shields.io/badge/Swift-5.1-orange.svg)
[![Build Status](https://travis-ci.com/bwetherfield/PitchSpellingModel.svg?branch=latest)](https://travis-ci.com/bwetherfield/PitchSpellingModel)
[![Code Coverage](Code Coverage)](https://codecov.io/github/bwetherfield/PitchSpellingModel)

## Contents

### Encodings

[`Encodings`](https://github.com/bwetherfield/PitchSpellingModel/tree/latest/Sources/Encodings) implements mappings between models of music, music notation and my Pitch Spelling Model. Models of music and music notation drawn from the **dn-m** ecosystem (_cf._ [`Music`](https://github.com/dn-m/Music), [`NotationModel`](https://github.com/dn-m/NotationModel)), .

### NetworkStructures

[`NetworkStructures`](https://github.com/bwetherfield/PitchSpellingModel/tree/latest/Sources/NetworkStructures) implements all the network operations and algorithms needed for the performance of Pitch Spelling Algorithms in forward and inverse directions.

### SpellingNetworks

[`SpellingNetworks`](https://github.com/bwetherfield/PitchSpellingModel/tree/latest/Sources/SpellingNetworks) specializes the **Encodings** and **NetworkStructures** modules to the use cases of the Pitch Spelling model.
