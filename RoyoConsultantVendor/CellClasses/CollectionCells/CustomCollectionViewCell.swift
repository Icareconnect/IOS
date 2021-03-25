//
//  CustomCollectionViewCell.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 17/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewTick: UIButton!
    
    var item: Any? {
        didSet {
            let obj = (item as? FilterOption)
            lblTitle.text = /obj?.option_name
            viewTick.isHidden = !(/obj?.isSelected)
            imgView.setImageNuke(obj?.image)
        }
    }
    
    
}
