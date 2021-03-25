//
//  SKLottieButton.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import Lottie
import AudioToolbox

class SKLottieButton: UIButton {
    
    private var linkedImage: UIImage?
    private var linkedText: String?
    private var defaultType = LottieFiles.BtnWhiteLoader
    
    lazy var loadingAnimation: AnimationView = {
        let anView = AnimationView()
        anView.backgroundColor = UIColor.clear
        anView.animation = Animation.named(defaultType.getFileName(), bundle: .main, subdirectory: nil, animationCache: nil)
        anView.loopMode = .loop
        anView.animationSpeed = 2.0
        anView.contentMode = .scaleAspectFit
        return anView
    }()
    
    public func setAnimationType(_ type: LottieFiles) {
        defaultType = type
    }
    
    public func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        shake()
    }
    
    public func playAnimation() {
        linkedText = title(for: .normal)
        linkedImage = image(for: .normal)
        
        setTitle(nil, for: .normal)
        setImage(nil, for: .normal)
        
        loadingAnimation.removeFromSuperview()
        let newFrame = bounds
        let NEW_TO_ADD: CGFloat = 24.0
        
        loadingAnimation.frame = CGRect.init(x: 0, y: newFrame.minY - (NEW_TO_ADD / 2.0), width: newFrame.width, height: newFrame.height + NEW_TO_ADD)
        addSubview(loadingAnimation)
        loadingAnimation.play()
        
        UIApplication.topVC()?.view.isUserInteractionEnabled = false
    }
    
    private func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    public func stop() {
        
        loadingAnimation.stop()
        loadingAnimation.removeFromSuperview()
        
        setTitle(linkedText, for: .normal)
        setImage(linkedImage, for: .normal)
        
        UIApplication.topVC()?.view.isUserInteractionEnabled = true
    }
}
