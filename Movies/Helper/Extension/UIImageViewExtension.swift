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
    
    func loadData(url: URL, forMovie movie: Movie?) {
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            
            guard let self = self,
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else { return }
            
            if let movie = movie {
                cacheImage.setObject(image as AnyObject, forKey: movie)
            }
            
            let imageUrl = url
            
            DispatchQueue.main.async {
                if imageUrl == url {
                    self.image = image
                }
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
