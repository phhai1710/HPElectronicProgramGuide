//
//  HPTimeMarkerContainerCell.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation
import UIKit

/**
 The root cell that will be used to subclass and add custom marker view inside
 */
open class HPTimeMarkerContainerCell: UICollectionViewCell {
    
    /// The view that take responsibility of containing all time marker's content.
    public let containerView = UIView()
    private var leadingContainerConstraint: NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        /*
         Align this container view at the leading side of this cell
         This container will be moved along with the timer
         */
        leadingContainerConstraint = NSLayoutConstraint(item: containerView,
                                                        attribute: .centerX,
                                                        relatedBy: .equal,
                                                        toItem: self.contentView,
                                                        attribute: .leading,
                                                        multiplier: 1,
                                                        constant: 0)
        leadingContainerConstraint?.isActive = true
        NSLayoutConstraint(item: containerView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: containerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        // Ignore touch on this cell
        self.isUserInteractionEnabled = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Align the marker along with the time interval
    ///
    /// - parameter offsetX: The position of time marker
    public func updateTimeMarker(at offsetX: CGFloat) {
        leadingContainerConstraint?.constant = offsetX
    }
}
