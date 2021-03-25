//
//  SidePanelCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SidePanelCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<SideMenueItem>
    
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var lblText: UILabel!
    
    var item: DefaultCellModel<SideMenueItem>? {
        didSet {
            imgBtn.setImage(item?.property?.model?.image, for: .normal)
            lblText.text = /item?.property?.model?.title?.localized
        }
    }
}
