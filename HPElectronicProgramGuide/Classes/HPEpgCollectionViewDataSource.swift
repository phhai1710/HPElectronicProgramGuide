//
//  HPEpgCollectionViewDataSource.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation

public protocol HPEpgCollectionViewDataSource: NSObject {
    func cellForFirstItem(at indexPath: IndexPath) -> HPEpgCollectionViewCell
    func cellForTimeItem(at timeInterval: Int,
                         indexPath: IndexPath) -> HPEpgCollectionViewCell
    func cellForChannelItem(at channelIndex: Int,
                            indexPath: IndexPath) -> HPEpgCollectionViewCell
    func cellForProgramItem(at programIndex: Int,
                            inChannel channelIndex: Int,
                            indexPath: IndexPath) -> HPProgramCollectionViewCell
    func cellForTimeMarker(at indexPath: IndexPath) -> HPTimeMarkerContainerCell
    
    
    func numberOfChannel() -> Int
    func numberOfProgram(inChannel channelIndex: Int) -> Int
    
    /// Returns the start second of a program within the entire timeline
    ///
    /// - parameter programIndex: The index of the program within the channel.
    /// - parameter channelIndex: The index of the channel.
    func startSecondOfProgram(at programIndex: Int,
                              inChannel channelIndex: Int) -> Int
    /// Returns the end second of a program within the entire timeline.
    ///
    /// - parameter programIndex: The index of the program within the channel.
    /// - parameter channelIndex: The index of the channel.
    func endSecondOfProgram(at programIndex: Int,
                            inChannel channelIndex: Int) -> Int
}
