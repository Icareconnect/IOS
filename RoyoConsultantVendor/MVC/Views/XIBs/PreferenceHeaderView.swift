//
//  PreferenceHeaderView.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 28/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class PreferenceHeaderView: UITableViewHeaderFooterView, ReusableHeaderFooter {
    
    typealias T = PreferenceHeaderProvider
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var item: PreferenceHeaderProvider? {
        didSet {
            lblTitle.text = /item?.headerProperty?.model?.preference_name
            backView.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 4.0)
            backView.clipsToBounds = true
        }
    }
    
}
