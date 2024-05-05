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
    public static let cellPadding: CGFloat = 2
    private let totalSecondsOfDay = 86400
    
    // MARK: - Properties
    private let epgLayout: HPEpgCollectionViewLayout
    private var secondInterval = [Int]()
    private let timeOffsetSecond: Int
    private let channelCellSize: CGSize
    private let timeCellSize: CGSize
    private var currentTimeIndicator: Int = 0
    
    public weak var epgDelegate: HPEpgCollectionViewDelegate?
    public weak var epgDataSource: HPEpgCollectionViewDataSource?
    
    // MARK: - Constructors
    public init(channelCellSize: CGSize,
                timeCellSize: CGSize,
                timeOffsetSecond: Int = 1800) {
        self.channelCellSize = channelCellSize
        self.timeCellSize = timeCellSize
        self.timeOffsetSecond = timeOffsetSecond
        self.epgLayout = HPEpgCollectionViewLayout(channelCellSize: channelCellSize,
                                                   timeCellSize: timeCellSize)
        super.init(frame: .zero, collectionViewLayout: epgLayout)
        
        setupTimeIntervals()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        epgLayout.delegate = self
        delegate = self
        dataSource = self
        bounces = false
    }
    
    private func setupTimeIntervals() {
        var i = 0
        while i * timeOffsetSecond < totalSecondsOfDay {
            secondInterval.append(i * timeOffsetSecond)
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
    private func getTimeIndicatorProgress(at second: Int) -> Float {
        return Float(second)/Float(totalSecondsOfDay)
    }
    
    /// Convert time from second to the position in X axis
    ///
    /// - parameter second: Time in second
    private func getTimeIndicatorOffsetX(at second: Int) -> CGFloat {
        return CGFloat(getTimeIndicatorProgress(at: second)) * epgLayout.timeRect().width
    }
    
    private func getCoveredVisibleProgramCells(in bounds: CGRect) -> [(IndexPath, CGFloat)] {
        let layoutAttributes = epgLayout.layoutAttributesForElements(in: bounds)
        
        var coveredCells = [(IndexPath, CGFloat)]()
        // Remove Channel column and Time row
        layoutAttributes?.forEach({ attribute in
            if !epgLayout.isChannelCell(indexPath: attribute.indexPath)
                && !epgLayout.isTimeCell(indexPath: attribute.indexPath) { // Ignore Channel column and Time row
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
    
    /// Layout position of the content inside **partially covered** program cells to make their content align to the left of the program section
    ///
    /// - parameter afterReload: **Yes** if we need to layout the `partially covered` program cells right after reload the collection view
    private func layoutCoveredVisibleProgramCells(afterReload: Bool) {
        var programBounds = CGRect(x: contentOffset.x,
                                   y: contentOffset.y,
                                   width: bounds.width,
                                   height: bounds.height)
        programBounds.origin.x = programBounds.origin.x + channelCellSize.width
        programBounds.origin.y = programBounds.origin.y + timeCellSize.height
        programBounds.size.width = programBounds.width - channelCellSize.width
        programBounds.size.height = programBounds.height - timeCellSize.height
        
        let coveredProgramCells = getCoveredVisibleProgramCells(in: programBounds)
        if afterReload {
            // We need to use performBatchUpdates to make sure the layouting process will perform after reload data
            performBatchUpdates { [unowned self] in
                coveredProgramCells.forEach { (indexPath, coveredWidth) in
                    (self.cellForItem(at: indexPath) as? HPProgramCollectionViewCell)?
                        .updateContentPosition(coveredWidth: coveredWidth)
                }
            }
        } else {
            coveredProgramCells.forEach { (indexPath, coveredWidth) in
                (self.cellForItem(at: indexPath) as? HPProgramCollectionViewCell)?
                    .updateContentPosition(coveredWidth: coveredWidth)
            }
        }
    }
    
    // MARK: - Public methods
    
    /// Set the position of time indicator on the screen
    ///
    /// - parameter second: Time in second
    public func setTimeIndicator(at second: Int) {
        self.currentTimeIndicator = second
        let offset = getTimeIndicatorOffsetX(at: second)
        (cellForItem(at: epgLayout.timeIndicatorIndexPath()) as? HPTimeIndicatorContainerCell)?.setTimeIndicator(at: offset)
    }
    
    public func getCurrentTimeIndicator() -> Int {
        return currentTimeIndicator
    }
    
    public func scrollToTime(at second: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let offset = self.getTimeIndicatorOffsetX(at: second)
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
        let fromSecond = Int(fromRatio * CGFloat(totalSecondsOfDay))
        let toSecond = Int(toRatio * CGFloat(totalSecondsOfDay))
        return (fromSecond, toSecond)
    }
    
    public func getTimeIndicatorIndexPath() -> IndexPath {
        return epgLayout.timeIndicatorIndexPath()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        layoutCoveredVisibleProgramCells(afterReload: false)
        
        let currentTimeRange = getCurrentTimeRange()
        epgDelegate?.didScrollToTimeRange(from: currentTimeRange.from, to: currentTimeRange.to)
    }
    
    /// Reload the collection layout to calculate cells again
    public func reloadLayout() {
        epgLayout.reloadLayout()
    }
    
    // MARK: - Override methods
    public override func reloadData() {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.layoutCoveredVisibleProgramCells(afterReload: true)
        }
        super.reloadData()
        CATransaction.commit()
    }
    
    public override func reloadSections(_ sections: IndexSet) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.layoutCoveredVisibleProgramCells(afterReload: true)
        }
        super.reloadSections(sections)
        CATransaction.commit()
    }
    
    public override func reloadItems(at indexPaths: [IndexPath]) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            self?.layoutCoveredVisibleProgramCells(afterReload: true)
        }
        super.reloadItems(at: indexPaths)
        CATransaction.commit()
    }
}

// MARK: - HPEpgCollectionViewLayoutDelegate
extension HPEpgCollectionView: HPEpgCollectionViewLayoutDelegate {
    public func startRatioPositionOfProgram(at indexPath: IndexPath) -> Float {
        let channelIndex = self.getChannelIndex(by: indexPath)
        let programIndex = self.getProgramIndex(by: indexPath)
        let startSecondOfProgram = Float(epgDataSource?.startSecondOfProgram(at: programIndex,
                                                                             inChannel: channelIndex) ?? 0)
        return startSecondOfProgram / Float(timeOffsetSecond)
    }
    
    public func endRatioPositionOfProgram(at indexPath: IndexPath) -> Float {
        let channelIndex = self.getChannelIndex(by: indexPath)
        let programIndex = self.getProgramIndex(by: indexPath)
        let endSecondOfProgram = Float(epgDataSource?.endSecondOfProgram(at: programIndex,
                                                                         inChannel: channelIndex) ?? 0)
        return endSecondOfProgram / Float(timeOffsetSecond)
    }
}

// MARK: - UICollectionViewDelegate
extension HPEpgCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        
        if indexPath == epgLayout.crossedCellIndexPath() {
            // didTapCrossedCell
        } else if indexPath == epgLayout.timeIndicatorIndexPath() {
            // didTapTimeIndicator
        } else if epgLayout.isTimeCell(indexPath: indexPath) {
            // didTapTime
        } else if epgLayout.isChannelCell(indexPath: indexPath) {
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
            // Only in section 0, we will add 1 more item for Time Indicator
            return epgLayout.timeStartItemIndex() + secondInterval.count
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
        
        if indexPath == epgLayout.crossedCellIndexPath() {
            cell = epgDataSource?.cellForCrossView(indexPath: indexPath)
            
            /**
             Because cell's padding of **HPEpgCollectionViewCell** is inside the cell, not in collection view,
             so to make the padding has the same color as collection view's background color,
             we will need to set the background color of the cell to match collection view's background color
             */
            cell?.backgroundColor = backgroundColor
        } else if indexPath == epgLayout.timeIndicatorIndexPath() {
            cell = epgDataSource?.cellForTimeIndicator(indexPath: indexPath)
        } else if epgLayout.isTimeCell(indexPath: indexPath) {
            let timeInterval: Int
            let timeIndex = getTimeIndex(by: indexPath)
            if timeIndex < secondInterval.count {
                timeInterval = secondInterval[timeIndex]
            } else {
                timeInterval = 0
            }
            cell = epgDataSource?.cellForTime(timeInterval: timeInterval,
                                              indexPath: indexPath)
            
            cell?.backgroundColor = backgroundColor
        } else if epgLayout.isChannelCell(indexPath: indexPath) {
            cell = epgDataSource?.cellForChannel(at: self.getChannelIndex(by: indexPath),
                                                 indexPath: indexPath)
            
            cell?.backgroundColor = backgroundColor
        } else { // Programs
            cell = epgDataSource?.cellForProgram(at: self.getProgramIndex(by: indexPath),
                                                 inChannel: self.getChannelIndex(by: indexPath),
                                                 indexPath: indexPath)
            
            cell?.backgroundColor = backgroundColor
        }
        
        return cell ?? UICollectionViewCell()
    }
}

extension HPEpgCollectionView
{
    func reloadDataThenPerform(_ closure: @escaping (() -> Void)) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(closure)
        super.reloadData()
        CATransaction.commit()
    }
}
