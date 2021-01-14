//
//  UIImageViewExtension.swift
//  Movies
//
//  Created by Administrator on 12.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit

// MARK: - UIImageView

extension UIImageView {
    
    // MARK: - Public methods
    
    func loadData(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    func toApplyBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
    }
}
