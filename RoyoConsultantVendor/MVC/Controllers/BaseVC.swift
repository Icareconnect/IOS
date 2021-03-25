//
//  BaseVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 27/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import Lottie

class BaseVC: UIViewController {
    
    lazy var nextBtnAccessory: NextButtonAccessory = {
        let rect = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width, height: 64)
        let continueAccessory = NextButtonAccessory(frame: rect)
        return continueAccessory
    }()
    
    lazy var dotsAnimationView: AnimationView = {
        let anView = AnimationView()
        anView.backgroundColor = UIColor.clear
        anView.animation = Animation.named(LottieFiles.Dots.getFileName(), bundle: .main, subdirectory: nil, animationCache: nil)
        anView.loopMode = .loop
        anView.animationSpeed = 2.0
        anView.contentMode = .scaleAspectFill
        return anView
    }()
    
    lazy var lineAnimation: AnimationView = {
        let anView = AnimationView()
        anView.backgroundColor = UIColor.clear
        anView.animation = Animation.named(LottieFiles.LineProgress.getFileName(), bundle: .main, subdirectory: nil, animationCache: nil)
        anView.animationSpeed = 2.0
        anView.loopMode = .loop
        anView.contentMode = .scaleAspectFit
        return anView
    }()
    
    lazy var uploadAnimation: AnimationView = {
        let anView = AnimationView()
        anView.backgroundColor = UIColor.clear
        anView.animation = Animation.named(LottieFiles.Uploading.getFileName(), bundle: .main, subdirectory: nil, animationCache: nil)
        anView.animationSpeed = 2.0
        anView.loopMode = .loop
        anView.contentMode = .scaleAspectFit
        return anView
    }()
    
    lazy var errorView: ErrorView = {
        let eView: ErrorView = .fromNib()
        return eView
    }()
    
    lazy var mediaPicker = SKMediaPicker.init(type: .ImageCameraLibrary)
    
    var tfResponder: TFResponder?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    public func playLineAnimation() {
        lineAnimation.removeFromSuperview()
        let width = UIScreen.main.bounds.width
        let height = width * (5 / 450) //According to resolution of lottie file 5 X 450
        let heightofTabBar = /self.tabBarController?.tabBar.bounds.height
        let yPoint = UIScreen.main.bounds.height - heightofTabBar
        let centerPointYAxis = yPoint - (height / 2)
        lineAnimation.frame = CGRect.init(x: 0, y: centerPointYAxis, width: width, height: height)
        view.addSubview(lineAnimation)
        lineAnimation.play()
    }
    
    public func stopLineAnimation() {
        lineAnimation.stop()
        lineAnimation.removeFromSuperview()
    }
    
    
    public func playUploadAnimation(on sampleView: UIView) {
        uploadAnimation.frame = sampleView.bounds
        sampleView.addSubview(uploadAnimation)
        uploadAnimation.play()
    }
    
    public func stopUploadAnimation() {
        uploadAnimation.stop()
        uploadAnimation.removeFromSuperview()
    }
    
    public func showVCPlaceholder(type: NoDataType, scrollView: UIScrollView?) {
        guard let scrollableView = scrollView else {
            return
        }
        errorView.frame = scrollableView.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            scrollableView.addSubview(self.errorView)
            self.errorView.showNoDataWithImage(type: type)
        }
    }
    
    public func showErrorView(error: String, scrollView: UIScrollView?, tapped: (() -> Void)?) {
        guard let scrollableView = scrollView else {
            return
        }
        errorView.frame = scrollableView.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let customErrorView = self?.errorView {
                scrollableView.addSubview(customErrorView)
                customErrorView.handleErrorView(animation: .ErrorEmoji, text: error, btnTitle: VCLiteral.RETRY.localized) {
                    tapped?()
                }
            }
        }
    }
}
