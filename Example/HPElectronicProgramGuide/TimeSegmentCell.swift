//
//  TimeSegmentCell.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation
import UIKit
import HPElectronicProgramGuide
import SnapKit

class TimeSegmentCell: HPEpgCollectionViewCell {
    // MARK: - Properties
    private let cornerRadius: CGFloat = 3
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightText
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cellBackgroundColor = .darkGray
        self.cellCornerRadius = cornerRadius
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
}
