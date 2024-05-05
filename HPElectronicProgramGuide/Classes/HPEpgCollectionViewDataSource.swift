//
//  HPEpgCollectionViewDataSource.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation

public protocol HPEpgCollectionViewDataSource: NSObject {
    func numberOfChannel() -> Int
    func numberOfProgram(inChannel channelIndex: Int) -> Int
    
    func cellForCrossView(indexPath: IndexPath) -> HPEpgCollectionViewCell
    func cellForTime(timeInterval: Int, indexPath: IndexPath) -> HPEpgCollectionViewCell
    func cellForChannel(at index: Int, indexPath: IndexPath) -> HPEpgCollectionViewCell
    func cellForProgram(at index: Int, inChannel channelIndex: Int, indexPath: IndexPath) -> HPProgramCollectionViewCell
    func cellForTimeIndicator(indexPath: IndexPath) -> HPTimeIndicatorContainerCell

    /// Get the start second of a program in the whole time line
    ///
    /// - parameter index: Index of program in a channel
    /// - parameter channelIndex: Index of Channel
    func startSecondOfProgram(at index: Int, inChannel channelIndex: Int) -> Int
    /// Get the end second of a program in the whole time line
    ///
    /// - parameter index: Index of program in a channel
    /// - parameter channelIndex: Index of Channel
    func endSecondOfProgram(at index: Int, inChannel channelIndex: Int) -> Int
}
