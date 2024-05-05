//
//  HPEpgCollectionViewCell.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation

/**
 The root cell that will be used to subclass and add custom content inside
 The container view will hold the content and the fake padding between cells
 */
open class HPEpgCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    @objc public var cellBackgroundColor: UIColor? {
        get {
            return backgroundContainerView.backgroundColor
        }
        set {
            backgroundContainerView.backgroundColor = newValue
        }
    }
    public var cellCornerRadius: CGFloat {
        get {
            return backgroundContainerView.layer.cornerRadius
        }
        set {
            backgroundContainerView.layer.cornerRadius = newValue
        }
    }
    
    @objc public var cellBorderColor: CGColor? {
        get {
            return backgroundContainerView.layer.borderColor
        }
        set {
            backgroundContainerView.layer.borderColor = newValue
        }
    }
    
    public var cellBorderWidth: CGFloat {
        get {
            return backgroundContainerView.layer.borderWidth
        }
        set {
            backgroundContainerView.layer.borderWidth = newValue
        }
    }
    
    /// The view that hold the background behinds the containerView
    public let backgroundContainerView = UIView()
    
    /// The view that take responsibility of containing all cell's content. 
    public var containerView: UIView {
        return backgroundContainerView
    }

    // MARK: - Constructors
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(backgroundContainerView)
        backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: backgroundContainerView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundContainerView,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .leading,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundContainerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: -HPEpgCollectionView.cellPadding).isActive = true
        NSLayoutConstraint(item: backgroundContainerView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .trailing,
                           multiplier: 1,
                           constant: -HPEpgCollectionView.cellPadding).isActive = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
}
