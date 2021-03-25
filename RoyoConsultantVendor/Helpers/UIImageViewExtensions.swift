//
//  UIImageViewExtensions.swift
//  GasItUpDriver
//
//  Created by Sandeep Kumar on 02/12/19.
//  Copyright © 2019 SandsHellCreations. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    func setImageNuke(_ imageOrURL: Any?, placeHolder: UIImage? = nil) {
        if let _image = imageOrURL as? UIImage {
            image = _image
        } else if let url = URL(string: ImageBasePath.thumbs.url + /(imageOrURL as? String)) {
            var request = ImageRequest(url: url)
            request.priority = .veryHigh
            Nuke.loadImage(with: request, options: ImageLoadingOptions(placeholder: placeHolder, transition: .fadeIn(duration: 0.33)), into: self, progress: nil) { (result) in
                switch result {
                case .success(let response):
                    Nuke.loadImage(with: ImageRequest(url: URL.init(string: ImageBasePath.upload.url + /(imageOrURL as? String))!), options: ImageLoadingOptions(placeholder: response.image, transition: .fadeIn(duration: 0.33)), into: self, progress: nil) { (result2) in
                        switch result2 {
                        case .success(let response2):
                            Nuke.loadImage(with: ImageRequest(url: URL.init(string: ImageBasePath.original.url + /(imageOrURL as? String))!), options: ImageLoadingOptions(placeholder: response2.image, transition: .fadeIn(duration: 0.33)), into: self, progress: nil, completion: nil)
                        case .failure(_):
                            break
                        }
                    }
                case .failure(_):
                    break
                }
            }
        } else {
            image = nil
        }
    }
    func setImageNuke2(_ imageOrURL: Any?, placeHolder: UIImage? = nil) {
        if let _image = imageOrURL as? UIImage {
            image = _image
        } else if let url = URL(string: /(imageOrURL as? String)) {
            var request = ImageRequest(url: url)
            request.priority = .veryHigh
            Nuke.loadImage(with: request, options: ImageLoadingOptions(placeholder: placeHolder, transition: .fadeIn(duration: 0.33)), into: self, progress: nil) { (result) in
                switch result {
                case .success(let response):
                    Nuke.loadImage(with: ImageRequest(url: URL.init(string: /(imageOrURL as? String))!), options: ImageLoadingOptions(placeholder: response.image, transition: .fadeIn(duration: 0.33)), into: self, progress: nil) { (result2) in
                        switch result2 {
                        case .success(let response2):
                            Nuke.loadImage(with: ImageRequest(url: URL.init(string: /(imageOrURL as? String))!), options: ImageLoadingOptions(placeholder: response2.image, transition: .fadeIn(duration: 0.33)), into: self, progress: nil, completion: nil)
                        case .failure(_):
                            break
                        }
                    }
                case .failure(_):
                    break
                }
            }
        } else {
            image = nil
        }
    }
    
    func setCategoryImage(imageOrURL: String?, size: CGSize) {
        
        ImageCache.shared.costLimit = 1024 * 1024 * 100 // 100 MB
        ImageCache.shared.countLimit = 100
        ImageCache.shared.ttl = 120
        
        let request = ImageRequest(url: URL.init(string: ImageBasePath.upload.url + /imageOrURL)!,
                                   processors: [ImageProcessor.Resize.init(size: size, unit: .points, contentMode: .aspectFit, crop: false, upscale: false)],
                                   priority: .veryHigh,
                                   options: .init(memoryCacheOptions: .init(isReadAllowed: true, isWriteAllowed: true), filteredURL: nil, cacheKey: nil, loadKey: nil, userInfo: nil))
        
        let options = ImageLoadingOptions(placeholder: nil,
                                          transition: .fadeIn(duration: 0.33),
                                          contentModes: .init(success: .bottomRight, failure: .bottomRight, placeholder: .bottomRight))
        Nuke.loadImage(with: request, options: options, into: self, progress: nil, completion: nil)
    }
}
