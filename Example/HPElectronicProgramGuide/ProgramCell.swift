//
//  ProgramCell.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation
import UIKit
import HPElectronicProgramGuide
import SnapKit

class ProgramCell: HPProgramCollectionViewCell {
    // MARK: - Properties
    private let cornerRadius: CGFloat = 3
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightText
        return label
    }()
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.containerView.addSubview(titleLabel)
        self.cellCornerRadius = cornerRadius
        self.cellBorderColor = UIColor.white.cgColor

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Public methods
    func setTitle(_ text: String?) {
        titleLabel.text = text
    }
    
    func setShouldHighlight(_ shouldHighlight: Bool, border: Bool) {
        cellBackgroundColor = shouldHighlight ?
        UIColor(red: 168/255, green: 168/255, blue: 168/255, alpha: 1) :
        UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        
        self.cellBorderWidth = border ? 2 : 0
    }
}
