//
//  Dictionary+Extension.swift
//  Pods
//
//  Created by Jerome Schmitz on 16.05.16.
//
//

import Foundation

extension Dictionary {
    mutating func unionInPlace(
        _ dictionary: Dictionary<Key, Value>) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
    // Thanks Airspeed Velocity
    mutating func unionInPlace<S: Sequence>(_ sequence: S) where
        S.Iterator.Element == (Key,Value) {
        for (key, value) in sequence {
            self[key] = value
        }
    }
}
