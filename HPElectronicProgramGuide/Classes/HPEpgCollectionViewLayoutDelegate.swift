//
//  HPEpgCollectionViewLayoutDelegate.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation

public protocol HPEpgCollectionViewLayoutDelegate: AnyObject {
    /// Get the start position(by ratio) of a program in the whole time line
    func startRatioPositionOfProgram(at indexPath: IndexPath) -> Float
    /// Get the end position(by ratio) of a program in the whole time line
    func endRatioPositionOfProgram(at indexPath: IndexPath) -> Float
}
