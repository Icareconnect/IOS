//
//  PreferenceSingleSelectionCell.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 07/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class PreferenceSingleSelectionCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    var item: Any? {
        didSet {
            lblName.text = /(item as? PreferenceOption)?.option_name
            viewDot.isHidden = !(/(item as? PreferenceOption)?.isSelected)
        }
    }
    
}

