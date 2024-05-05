//
//  HPEpgCollectionViewDelegate.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation

public protocol HPEpgCollectionViewDelegate: NSObject {
    func didSelectChannel(at index: Int, indexPath: IndexPath)
    func didSelectProgram(at index: Int, inChannel channelIndex: Int, indexPath: IndexPath)
    func didScrollToTimeRange(from: Int, to: Int)
}
