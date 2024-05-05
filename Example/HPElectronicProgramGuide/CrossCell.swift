//
//  CrossCell.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation
import UIKit
import HPElectronicProgramGuide
import SnapKit

class CrossCell: HPEpgCollectionViewCell {
    // MARK: - Properties
    private let cornerRadius: CGFloat = 6
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .darkGray
        self.cellCornerRadius = cornerRadius
        
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
}
