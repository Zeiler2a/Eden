//
//  EnumCollection.swift
//  Eden Team Builder
//
//  Created by Sébastien Gilabert on 16/05/2018.
//  Copyright © 2018 Sébastien Gilabert. All rights reserved.
//

import Foundation

protocol EnumCollection : Hashable {}

extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}
