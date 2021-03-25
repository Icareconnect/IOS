//
//  RecieverImgCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 20/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class RecieverImgCell: BaseChatCell {

    override func setupData() {
        super.setupData()
        let obj = item?.property?.model
        imgView.setImageNuke(/obj?.imageUrl, placeHolder: nil)
        viewBack.roundCorners(with: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], radius: 16.0)
        imgView.roundCorners(with: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], radius: 16.0)
    }
}
