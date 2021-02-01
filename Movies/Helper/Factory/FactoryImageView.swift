//
//  FactoryImageView.swift
//  Movies
//
//  Created by Administrator on 01.02.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit

// MARK: - FactoryImageView

class FactoryImageView {
    
    static let shared = FactoryImageView()
    
    func createImageView() -> UIImageView {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true        
        imageView.sizeToFit()
        return imageView
    }
}
