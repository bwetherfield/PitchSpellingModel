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

struct UnassignedInnerNode: Hashable {
    let index: Cross<Int, Tendency>
}
