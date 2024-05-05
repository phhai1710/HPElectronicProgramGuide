//
//  TimeIndicatorCell.swift
//  HPElectronicProgramGuide
//
//  Created by Hai Pham on 02/24/2024.
//  Copyright (c) 2024 Hai Pham. All rights reserved.
//

import Foundation
import UIKit
import HPElectronicProgramGuide
import SnapKit

class TimeIndicatorCell: HPTimeIndicatorContainerCell {
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.7)
        label.textColor = .white
        return label
    }()
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        return view
    }()
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.addSubview(timeLabel)
        containerView.addSubview(indicatorView)
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
        }
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.centerX.equalTo(timeLabel)
            make.bottom.equalToSuperview()
            make.width.equalTo(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func updateTimeLabel(_ text: String) {
        timeLabel.text = text
    }
}
