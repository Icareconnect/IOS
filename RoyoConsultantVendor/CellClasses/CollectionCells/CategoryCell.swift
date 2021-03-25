//
//  CategoryCell.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 28/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var imageSize: CGSize?
    
    var item: Any? {
        didSet {
            let obj = item as? Category
            lblTitle.text = /obj?.name
            backGroundView.backgroundColor = UIColor.init(hex: /obj?.color_code?.lowercased())
            imgView.setCategoryImage(imageOrURL: /obj?.image, size: imageSize ?? CGSize.zero)
        }
    }
    
}
