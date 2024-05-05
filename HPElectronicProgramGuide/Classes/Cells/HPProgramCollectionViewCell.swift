//
//  HPProgramCollectionViewCell.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation

/**
 The root cell that will be used to subclass and add custom program view inside
 Content of the program will be moved along with the user's scroll
 */
open class HPProgramCollectionViewCell: HPEpgCollectionViewCell {
    // MARK: - Properties
    
    /// This view will be used for keeping this container showing on the screen along with the user's scroll
    public let _containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    public override var containerView: UIView {
        return _containerView
    }
    private var containerLeadingConstraint: NSLayoutConstraint?
    
    // MARK: - Constructors
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundContainerView.addSubview(_containerView)
        _containerView.translatesAutoresizingMaskIntoConstraints = false
        /*
         Align this container view at the leading side of this cell
         This container will be moved along with the user's scroll
         */
        containerLeadingConstraint = NSLayoutConstraint(item: _containerView,
                                                        attribute: .leading,
                                                        relatedBy: .lessThanOrEqual,
                                                        toItem: self.backgroundContainerView,
                                                        attribute: .leading,
                                                        multiplier: 1,
                                                        constant: 0)
        containerLeadingConstraint?.isActive = true
        NSLayoutConstraint(item: _containerView,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.backgroundContainerView,
                           attribute: .trailing,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: _containerView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.backgroundContainerView,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: _containerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.backgroundContainerView,
                           attribute: .bottom,
                           multiplier: 1,
                           constant: 0).isActive = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func updateContentPosition(coveredWidth: CGFloat) {
        containerLeadingConstraint?.constant = coveredWidth
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        containerLeadingConstraint?.constant = 0
    }
}
