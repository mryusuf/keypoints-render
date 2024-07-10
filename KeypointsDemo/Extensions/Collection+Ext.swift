//
//  Collection+Ext.swift
//  KeypointsDemo
//
//  Created by Indra on 10/07/24.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
