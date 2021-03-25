//
//  SubcategoryCell.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 28/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SubcategoryCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Category>
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var item: DefaultCellModel<Category>? {
        didSet {
            let obj = item?.property?.model
            lblTitle.text = /obj?.name
            imgView.setImageNuke(/obj?.image, placeHolder: #imageLiteral(resourceName: "ic_category"))
        }
    }
    
}
