//
//  HPEpgCollectionViewLayout.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation
import UIKit

/**
 The custom layout to create complex collection view
 
 This layout is designed to mimic a Spreadsheet-like view for a EPG collection. It consists of rows and columns, where sections represent rows and items represent columns. The main axis is defined by Section 0 and Item 0.
 
 To handle the Time Marker cell, a Time Marker cell is added between the First cell and Time cells in Section 0 - Item 1. The Time Marker frame spans the entire collection view except the Channel column, allowing the custom marker (inside the Time Marker cell) to move from the start to the end of the Time cells.
 
 
 - Section 0:                             Time row
 - Item 0:                                  Channel column
 - Section 0 - Item 0:                The first cell between Time row and Channel column
 - Section 1...n - Item 0:           Channel cells
 - Section 0 - Item 1:                Time Marker
 - Section 0 - Item 2...n:           Time cells
 - Section 1..n - Item 2...n:       Program grids
 
 Cell Behavior When Scrolling:
 - First cell: This cell remains visible on the screen regardless of horizontal or vertical scrolling.
 - Time cells: These cells remain visible on the screen during vertical scrolling.
 - Channel cells: These cells remain visible on the screen during horizontal scrolling.
 - Time Marker cell: This cell remains visible on the screen during vertical scrolling.
 */
public class HPEpgCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    private let channelItemSize: CGSize
    private let timeItemSize: CGSize
    private var firstItemSize: CGSize {
        return CGSize(width: channelItemSize.width, height: timeItemSize.height)
    }
    private var isDataSourceUpdated = true
    private var layoutContentSize = CGSize.zero
    
    public weak var layoutDelegate: HPEpgCollectionViewLayoutDelegate?
    var cellAttributesCache = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()

    // MARK: - Constructors
    public init(channelItemSize: CGSize = CGSize(width: 60, height: 60),
                timeItemSize: CGSize = CGSize(width: 120, height: 30)) {
        self.channelItemSize = channelItemSize
        self.timeItemSize = timeItemSize
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepare() {
        super.prepare()
        
        if !isDataSourceUpdated {
            // If the data source hasn't been updated, adjust cached cell positions based on content offset.

            let contentOffset = collectionView?.contentOffset ?? .zero
            
            if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
                for sectionIndex in 0..<sectionCount {
                    if let itemCount = collectionView?.numberOfItems(inSection: sectionIndex),
                       itemCount > 0 {
                        for itemIndex in 0..<itemCount {
                            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                            
                            if var attributes = cellAttributesCache[indexPath] {
                                // Adjust the position of the cached cell attributes to follow the content offset.
                                calculateNewRectOfCell(for: &attributes, toFollow: contentOffset)
                            }
                        }
                    }
                }
            }
        } else {
            // Initial layout calculation for each cell. Subsequent calculations only adjust X and Y positions.
            isDataSourceUpdated = false
            
            if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
                for sectionIndex in 0..<sectionCount {
                    // Section 0: Time
                    // Section 1...N: Channels and Programs
                    if let itemCount = collectionView?.numberOfItems(inSection: sectionIndex),
                       itemCount > 0 {
                        for itemIndex in 0..<itemCount {
                            // Item 0: Channel column
                            // Section 0 - Item 1: Time Marker
                            // Section 0 - Item 2+: Time row
                            // Section 1+ - Item 2+: Program grids
                            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                            let cellAttributes = computeCellAttributes(in: indexPath)
                            
                            // Cache the computed cell attributes.
                            cellAttributesCache[indexPath] = cellAttributes
                        }
                    }
                }
            }
            
            // Calculate the overall content size of the collection view
            self.layoutContentSize = getContentSize()
        }
    }
    
    public override var collectionViewContentSize: CGSize {
        return self.layoutContentSize
    }
    
    public override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        // RtL
        return true
    }
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                             withScrollingVelocity velocity: CGPoint) -> CGPoint {
        /**
         Enable paging behavior when scrolling
         Focus collection view at the beginning of the Time cell when scrolling
         */
        let expectedIndex = (proposedContentOffset.x / timeItemSize.width).rounded()
        let expectedX: CGFloat
        let collectionViewWidth = collectionView?.frame.width ?? 0
        if proposedContentOffset.x + collectionViewWidth == layoutContentSize.width {
            // Reach to end
            expectedX = proposedContentOffset.x
        } else {
            expectedX = expectedIndex * timeItemSize.width
        }
        return CGPointMake(expectedX, proposedContentOffset.y)
    }
    
    /**
     Calculate size and position of cell
     */
    private func computeCellAttributes(in indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let contentOffset = collectionView?.contentOffset ?? .zero
        
        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        if indexPath == firstCellIndexPath() {
            cellAttributes.frame = CGRect(x: contentOffset.x,
                                          y: contentOffset.y,
                                          width: firstItemSize.width,
                                          height: firstItemSize.height)
            cellAttributes.zIndex = 5
        } else if isChannelItem(indexPath: indexPath) {
            let yPosition = timeItemSize.height + (CGFloat(indexPath.section - channelStartSectionIndex()) * (channelItemSize.height))
            cellAttributes.frame = CGRect(x: contentOffset.x,
                                          y: yPosition,
                                          width: channelItemSize.width,
                                          height: channelItemSize.height)
            
            cellAttributes.zIndex = 4
        } else if indexPath == timeMarkerIndexPath() {
            cellAttributes.frame = CGRect(x: firstItemSize.width,
                                          y: contentOffset.y,
                                          width: timeMarkerRect().width,
                                          height: timeMarkerRect().height)
            cellAttributes.zIndex = 3
        } else if isTimeItem(indexPath: indexPath) {
            let xPosition = channelItemSize.width + (CGFloat(indexPath.item - timeStartItemIndex()) * timeItemSize.width)
            cellAttributes.frame = CGRect(x: xPosition,
                                          y: contentOffset.y,
                                          width: timeItemSize.width,
                                          height: timeItemSize.height)
            
            cellAttributes.zIndex = 2
        } else { // Programs grid
            /**
             The first item(sectionIndex = 0) is Time row and it has different height from **Channel cell height**, so we will need to add it manually
             */
            let yPosition = timeItemSize.height + (CGFloat(indexPath.section - channelStartSectionIndex()) * (channelItemSize.height))
            
            // Calculate the size of cell based on the ratio
            let startPosition = layoutDelegate?.startRatioPositionOfProgram(at: indexPath) ?? 0
            let startXWithoutChannelColumn = CGFloat(startPosition) * timeItemSize.width
            
            let endPosition = layoutDelegate?.endRatioPositionOfProgram(at: indexPath) ?? 0
            let xPosition = channelItemSize.width + startXWithoutChannelColumn
            let width = CGFloat(endPosition - startPosition) * timeItemSize.width
            
            cellAttributes.frame = CGRect(x: xPosition,
                                          y: yPosition,
                                          width: width,
                                          height: channelItemSize.height)
            
            cellAttributes.zIndex = 1
        }
        
        return cellAttributes
    }
    
    /**
     Calculate new position of **sticky cell** that need to be stayed on the screen along with the user's scroll
     */
    private func calculateNewRectOfCell(for cellAttributes: inout UICollectionViewLayoutAttributes,
                                        toFollow scrollViewContentOffset: CGPoint) {
        let indexPath = cellAttributes.indexPath
        
        if indexPath == firstCellIndexPath() {
            // First cell need to be stuck on both horizontal and vertical scroll
            cellAttributes.frame.origin.x = scrollViewContentOffset.x
            cellAttributes.frame.origin.y = scrollViewContentOffset.y
        } else if indexPath == timeMarkerIndexPath() {
            cellAttributes.frame.origin.y = scrollViewContentOffset.y
        } else if isTimeItem(indexPath: indexPath) {
            // Time cell need to be stuck on both vertical scroll
            cellAttributes.frame.origin.y = scrollViewContentOffset.y
        } else if isChannelItem(indexPath: indexPath) { // Channel columns
            // Channel cell need to be stuck on both horizontal scroll
            cellAttributes.frame.origin.x = scrollViewContentOffset.x
        }
    }
    
    /// Determine and return the content size of the collection view
    private func getContentSize() -> CGSize {
        let numberOfItemInChannelColumn = collectionView?.numberOfSections ?? 0 // Channels count
        let numberOfItemInTimeRow = collectionView?.numberOfItems(inSection: 0) ?? 0 // Time count
        
        
        let contentWidth = (Double(numberOfItemInTimeRow - timeStartItemIndex()) * timeItemSize.width) + firstItemSize.width
        let contentHeight = (Double(numberOfItemInChannelColumn - channelStartSectionIndex()) * channelItemSize.height) + firstItemSize.height
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        for cellAttributes in cellAttributesCache.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        return attributesInRect
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributesCache[indexPath]
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Render again to make Channel column and Time row sticky
        return true
    }
    
    public func reloadLayout() {
        cellAttributesCache.removeAll()
        isDataSourceUpdated = true
        invalidateLayout()
    }
    
    func firstCellIndexPath() -> IndexPath {
        return IndexPath(item: 0, section: 0)
    }
    
    func timeMarkerIndexPath() -> IndexPath {
        return IndexPath(item: 1, section: 0)
    }
    
    func isChannelItem(indexPath: IndexPath) -> Bool {
        return indexPath.section >= channelStartSectionIndex() && indexPath.item == 0
    }
    
    func isTimeItem(indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 && indexPath.item >= timeStartItemIndex()
    }
    
    /// The first item index of time cells
    func timeStartItemIndex() -> Int {
        return 2 // 1st cell is First cell and 2nd cell is Time Marker
    }
    
    /// The first section index of channel cells
    func channelStartSectionIndex() -> Int {
        return 1 // 1st cell is First cell
    }
    
    /// The first section index of Program cells
    func programStartSectionIndex() -> Int {
        return 1 // 1st cell is Time cell
    }
    
    /// The first item index of Program cells
    func programStartItemIndex() -> Int {
        return 1 // 1st cell is Channel cell
    }
    
    /// Position rect of Program grid
    public func programsRect() -> CGRect {
        let contentSize = getContentSize()
        
        return CGRect(x: channelItemSize.width,
                      y: timeItemSize.height,
                      width: contentSize.width - channelItemSize.width,
                      height: contentSize.height - timeItemSize.height)
    }
    
    /// Position rect of Time row
    public func timeRect() -> CGRect {
        let contentSize = getContentSize()
        
        return CGRect(x: channelItemSize.width,
                      y: 0,
                      width: contentSize.width - channelItemSize.width,
                      height: timeItemSize.height)
    }
    
    /// Position rect of Time Marker cell
    public func timeMarkerRect() -> CGRect {
        let contentSize = getContentSize()
        
        // Time Marker container should fill the whole collection view except Channel cells
        return CGRect(x: channelItemSize.width,
                      y: 0,
                      width: contentSize.width - channelItemSize.width,
                      height: contentSize.height)
    }
}
