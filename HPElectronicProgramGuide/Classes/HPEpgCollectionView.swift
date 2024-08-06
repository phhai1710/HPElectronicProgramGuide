//
//  HPEpgCollectionView.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation
import UIKit

public class HPEpgCollectionView: UICollectionView {
    
    // MARK: Constants
    public static let itemPadding: CGFloat = 2
    private let secondsInDay = 86400
    
    // MARK: - Properties
    private let epgLayout: HPEpgCollectionViewLayout
    private var timeSegments = [Int]()
    private let offsetSeconds: Int
    private let channelItemSize: CGSize
    private let timeItemSize: CGSize
    private var currentTimeMarker: Int = 0
    private var reloadDataCompletion: (() -> ())?
    
    public weak var epgDelegate: HPEpgCollectionViewDelegate?
    public weak var epgDataSource: HPEpgCollectionViewDataSource?
    
    // MARK: - Constructors
    public init(channelItemSize: CGSize,
                timeItemSize: CGSize,
                offsetSeconds: Int = 1800) {
        self.channelItemSize = channelItemSize
        self.timeItemSize = timeItemSize
        self.offsetSeconds = offsetSeconds
        self.epgLayout = HPEpgCollectionViewLayout(channelItemSize: channelItemSize,
                                                   timeItemSize: timeItemSize)
        super.init(frame: .zero, collectionViewLayout: epgLayout)
        
        setupTimeSegments()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let reloadDataCompletion {
            reloadDataCompletion()
            self.reloadDataCompletion = nil
        }
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        epgLayout.layoutDelegate = self
        delegate = self
        dataSource = self
        bounces = false
    }
    
    private func setupTimeSegments() {
        var i = 0
        while i * offsetSeconds < secondsInDay {
            timeSegments.append(i * offsetSeconds)
            i += 1
        }
    }
    
    private func getChannelIndex(by indexPath: IndexPath) -> Int {
        return indexPath.section - epgLayout.channelStartSectionIndex()
    }
    
    private func getTimeIndex(by indexPath: IndexPath) -> Int {
        return indexPath.item - epgLayout.timeStartItemIndex()
    }
    
    private func getProgramIndex(by indexPath: IndexPath) -> Int {
        return indexPath.item - epgLayout.programStartItemIndex()
    }
    
    /// Convert time from second to the percent of total timeline
    ///
    /// - parameter second: Time in second
    private func getTimeMarkerProgress(at second: Int) -> Float {
        return Float(second)/Float(secondsInDay)
    }
    
    /// Convert time from second to the position in X axis
    ///
    /// - parameter second: Time in second
    private func getTimeMarkerOffsetX(at second: Int) -> CGFloat {
        return CGFloat(getTimeMarkerProgress(at: second)) * epgLayout.timeRect().width
    }
    
    private func getCoveredVisibleProgramCells(in bounds: CGRect) -> [(IndexPath, CGFloat)] {
        let layoutAttributes = epgLayout.layoutAttributesForElements(in: bounds)
        
        var coveredCells = [(IndexPath, CGFloat)]()
        // Remove Channel column and Time row
        layoutAttributes?.forEach({ attribute in
            if !epgLayout.isChannelItem(indexPath: attribute.indexPath)
                && !epgLayout.isTimeItem(indexPath: attribute.indexPath) { // Ignore Channel column and Time row
                if attribute.frame.minX < bounds.minX && attribute.frame.maxX > bounds.minX {
                    let coveredWidth = bounds.minX - attribute.frame.minX
                    coveredCells.append((attribute.indexPath, coveredWidth))
                } else {
                    coveredCells.append((attribute.indexPath, 0))
                }
            }
        })
        return coveredCells
    }
    
    /// Aligns the content inside **partially visible** program cells to the left of the program section.
    private func alignPartiallyVisibleProgramCells() {
        var adjustedProgramBounds = CGRect(x: contentOffset.x,
                                           y: contentOffset.y,
                                           width: bounds.width,
                                           height: bounds.height)
        adjustedProgramBounds.origin.x += channelItemSize.width
        adjustedProgramBounds.origin.y += timeItemSize.height
        adjustedProgramBounds.size.width -= channelItemSize.width
        adjustedProgramBounds.size.height -= timeItemSize.height
        
        let coveredProgramCells = getCoveredVisibleProgramCells(in: adjustedProgramBounds)
        // Ensure the layout process occurs after reloading data
        performBatchUpdates { [unowned self] in
            coveredProgramCells.forEach { (indexPath, coveredWidth) in
                (self.cellForItem(at: indexPath) as? HPProgramCollectionViewCell)?
                    .updateContentPosition(coveredWidth: coveredWidth)
            }
        }
    }
    
    // MARK: - Public methods
    
    /// Update the position of time marker on the screen
    ///
    /// - parameter timeInSeconds: Time in second
    public func updateTimeMarker(at timeInSeconds: Int) {
        self.currentTimeMarker = timeInSeconds
        let offset = getTimeMarkerOffsetX(at: timeInSeconds)
        (cellForItem(at: epgLayout.timeMarkerIndexPath()) as? HPTimeMarkerContainerCell)?.updateTimeMarker(at: offset)
    }
    
    public func getCurrentTimeMarker() -> Int {
        return currentTimeMarker
    }
    
    public func scrollToTime(at second: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let offset = self.getTimeMarkerOffsetX(at: second)
            self.scrollRectToVisible(CGRect(x: max(0, offset - 80),
                                            y: self.contentOffset.y,
                                            width: self.frame.width,
                                            height: self.frame.height),
                                     animated: true)
        }
    }
    
    public func getCurrentTimeRange() -> (from: Int, to: Int) {
        let currentOffsetX = contentOffset.x
        let fromRatio = currentOffsetX / epgLayout.timeRect().width
        let toRatio = (currentOffsetX + frame.width - epgLayout.timeRect().minX) / epgLayout.timeRect().width
        let fromSecond = Int(fromRatio * CGFloat(secondsInDay))
        let toSecond = Int(toRatio * CGFloat(secondsInDay))
        return (fromSecond, toSecond)
    }
    
    public func getTimeMarkerIndexPath() -> IndexPath {
        return epgLayout.timeMarkerIndexPath()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        alignPartiallyVisibleProgramCells()
        
        let currentTimeRange = getCurrentTimeRange()
        epgDelegate?.didScrollToTimeRange(from: currentTimeRange.from, to: currentTimeRange.to)
    }
    
    /// Reload the collection layout to calculate cells again
    public func reloadLayout() {
        epgLayout.reloadLayout()
    }
    
    // MARK: - Override methods
    public override func reloadData() {
        reloadDataCompletion = { [weak self] in
            self?.alignPartiallyVisibleProgramCells()
        }
        super.reloadData()
    }
    
    public override func reloadSections(_ sections: IndexSet) {
        reloadDataCompletion = { [weak self] in
            self?.alignPartiallyVisibleProgramCells()
        }
        super.reloadSections(sections)
    }
    
    public override func reloadItems(at indexPaths: [IndexPath]) {
        reloadDataCompletion = { [weak self] in
            self?.alignPartiallyVisibleProgramCells()
        }
        super.reloadItems(at: indexPaths)
    }
}

// MARK: - HPEpgCollectionViewLayoutDelegate
extension HPEpgCollectionView: HPEpgCollectionViewLayoutDelegate {
    public func startRatioPositionOfProgram(at indexPath: IndexPath) -> Float {
        let channelIndex = self.getChannelIndex(by: indexPath)
        let programIndex = self.getProgramIndex(by: indexPath)
        let startSecondOfProgram = Float(epgDataSource?.startSecondOfProgram(at: programIndex,
                                                                             inChannel: channelIndex) ?? 0)
        return startSecondOfProgram / Float(offsetSeconds)
    }
    
    public func endRatioPositionOfProgram(at indexPath: IndexPath) -> Float {
        let channelIndex = self.getChannelIndex(by: indexPath)
        let programIndex = self.getProgramIndex(by: indexPath)
        let endSecondOfProgram = Float(epgDataSource?.endSecondOfProgram(at: programIndex,
                                                                         inChannel: channelIndex) ?? 0)
        return endSecondOfProgram / Float(offsetSeconds)
    }
}

// MARK: - UICollectionViewDelegate
extension HPEpgCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        if indexPath == epgLayout.firstCellIndexPath() {
            // Handle tap first item
        } else if indexPath == epgLayout.timeMarkerIndexPath() {
            // Handle tap time marker
        } else if epgLayout.isTimeItem(indexPath: indexPath) {
            // Handle tap time
        } else if epgLayout.isChannelItem(indexPath: indexPath) {
            epgDelegate?.didSelectChannel(at: getChannelIndex(by: indexPath), indexPath: indexPath)
        } else { // Programs
            epgDelegate?.didSelectProgram(at: self.getProgramIndex(by: indexPath),
                                          inChannel: self.getChannelIndex(by: indexPath),
                                          indexPath: indexPath)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HPEpgCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { // Time row
            // Only in section 0, we will add 1 more item for Time Marker
            return epgLayout.timeStartItemIndex() + timeSegments.count
        } else {
            let tempIndexPath = IndexPath(item: 0, section: section)
            let channelIndex = self.getChannelIndex(by: tempIndexPath)
            return epgLayout.programStartItemIndex() + (epgDataSource?.numberOfProgram(inChannel: channelIndex) ?? 0)
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return epgLayout.channelStartSectionIndex() + (epgDataSource?.numberOfChannel() ?? 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        if indexPath == epgLayout.firstCellIndexPath() {
            cell = epgDataSource?.cellForFirstItem(at: indexPath)
            
            /**
             The padding of **HPEpgCollectionViewCell** is implemented inside the cell itself, rather than in the collection view.
             To ensure that the padding has the same color as the collection view's background color,
             we need to set the background color of the cell to match the background color of the collection view.
             */
            cell?.backgroundColor = backgroundColor
        } else if indexPath == epgLayout.timeMarkerIndexPath() {
            cell = epgDataSource?.cellForTimeMarker(at: indexPath)
        } else if epgLayout.isTimeItem(indexPath: indexPath) {
            let timeSegment: Int
            let timeIndex = getTimeIndex(by: indexPath)
            if timeIndex < timeSegments.count {
                timeSegment = timeSegments[timeIndex]
            } else {
                timeSegment = 0
            }
            cell = epgDataSource?.cellForTimeItem(at: timeSegment,
                                                  indexPath: indexPath)
            
            cell?.backgroundColor = backgroundColor
        } else if epgLayout.isChannelItem(indexPath: indexPath) {
            cell = epgDataSource?.cellForChannelItem(at: self.getChannelIndex(by: indexPath),
                                                     indexPath: indexPath)
            
            cell?.backgroundColor = backgroundColor
        } else { // Programs
            cell = epgDataSource?.cellForProgramItem(at: self.getProgramIndex(by: indexPath),
                                                     inChannel: self.getChannelIndex(by: indexPath),
                                                     indexPath: indexPath)
            
            cell?.backgroundColor = backgroundColor
        }
        
        return cell ?? UICollectionViewCell()
    }
}
