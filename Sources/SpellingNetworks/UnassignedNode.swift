//
//  UnassignedNode.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 8/27/19.
//

import Encodings
import NetworkStructures
import DataStructures

typealias UnassignedNode = FlowNode<UnassignedInnerNode>
typealias UnassignedInnerNode = Cross<Int, Tendency>

extension Cross where A == Int, B == Tendency {

    var index: Cross<Int, Tendency> { return self }
}
