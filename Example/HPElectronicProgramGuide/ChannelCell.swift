//
//  ChannelCell.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation
import UIKit
import HPElectronicProgramGuide
import SnapKit

class ChannelCell: HPEpgCollectionViewCell {
    // MARK: - Properties
    private let cornerRadius: CGFloat = 3
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        self.cellCornerRadius = cornerRadius
        self.cellBorderColor = UIColor.systemGreen.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
    
    func setShouldHighlight(_ shouldHighlight: Bool) {
        cellBackgroundColor = shouldHighlight ?
        UIColor(red: 26/255, green: 176/255, blue: 209/255, alpha: 1) :
            .darkGray
    }
}
