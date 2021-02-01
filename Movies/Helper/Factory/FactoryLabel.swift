//
//  FactoryLabel.swift
//  Movies
//
//  Created by Administrator on 01.02.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit

// MARK: - FactoryLabel

class FactoryLabel {
    
    static let shared = FactoryLabel()
    
    func createLabel(fontOfSize fontSize: CGFloat, andColor color: UIColor) -> UILabel {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: fontSize)
        label.textColor = color
        label.sizeToFit()
        return label
    }
}
