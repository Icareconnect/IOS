//
//  SenderImgCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 20/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SenderImgCell: BaseChatCell {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var btnStatus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var didTapUploadImageRetry: ((_ _message: Message?, _ _image: UIImage?) -> Void)?
    
    override func setupData() {
        super.setupData()
        let obj = item?.property?.model
        
        switch item?.uploadStatus ?? .Default {
        case .Default, .UploadingFinished:
            imgView.setImageNuke(/obj?.imageUrl, placeHolder: nil)
            visualEffectView.isHidden = true
            uploadingAnimation.removeFromSuperview()
            errorAnimation.removeFromSuperview()
            uploadingAnimation.stop()
            btnRetry.isHidden = true
        case .Uploading:
            uploadingAnimation.removeFromSuperview()
            errorAnimation.removeFromSuperview()
            uploadingAnimation.frame = visualEffectView.bounds
            visualEffectView.contentView.addSubview(uploadingAnimation)
            visualEffectView.isHidden = false
            uploadingAnimation.play()
            btnRetry.isHidden = true
        case .Error(let error):
            uploadingAnimation.removeFromSuperview()
            errorAnimation.removeFromSuperview()
            uploadingAnimation.stop()
            btnRetry.isHidden = false
            errorAnimation.frame = viewError.bounds
            viewError.addSubview(errorAnimation)
            errorAnimation.play()
            
            visualEffectView.isHidden = false
        }
        if let localImage = item?.localImage {
            imgView.image = localImage
        } else {
            imgView.setImageNuke(/obj?.imageUrl, placeHolder: nil)
        }
        viewBack.roundCorners(with: [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 16.0)
        imgView.roundCorners(with: [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 16.0)
        visualEffectView.roundCorners(with: [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 16.0)
        visualEffectView.clipsToBounds = true
        
        btnStatus.isHidden = obj?.status?.statusImage == nil
        btnStatus.setImage(obj?.status?.statusImage, for: .normal)
        btnStatus.tintColor = obj?.status?.tintColor
    }
    
    @IBAction func btnRetryAction(_ sender: UIButton) {
        item?.uploadStatus = .Uploading
        didTapUploadImageRetry?(item?.property?.model, imgView.image)
    }
    
}
