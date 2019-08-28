//
//  GraphSchemeProtocol.swift
//  SpelledPitch
//
//  Created by Benjamin Wetherfield on 03/11/2018.
//

import DataStructures

public protocol GraphSchemeProtocol {
    associatedtype Node
    associatedtype Edge: SymmetricPair where Edge.A == Node
}
