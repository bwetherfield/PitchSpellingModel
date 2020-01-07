//
//  Get.swift
//  SpellingNetworks
//
//  Created by Benjamin Wetherfield on 1/6/20.
//

func get<A, B> (_ path: KeyPath<A, B>) -> (A) -> B {
    return { $0[keyPath: path] }
}
