//
//  Array+Extensions.swift
//  HPElectronicProgramGuide_Example
//
//  Created by Hai Pham Huu on 25/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

extension Array {
    public func get(_ index: Int) -> Element? {
        if index < self.count {
            return self[index]
        }
        return nil
    }
    public func filteredByType<T> (_ : T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
