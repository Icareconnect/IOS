//
//  CategoryCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 31/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class PreferencesCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<PreferenceOption>
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelected: UIButton!

    var item: DefaultCellModel<PreferenceOption>? {
        didSet {
            lblTitle.text = /item?.property?.model?.option_name
            btnSelected.isSelected = /item?.property?.model?.isSelected
        }
    }
}

class WorkCell: UITableViewCell, ReusableCell {
    
    typealias T = WorkCellProvider

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelected: UIButton!

    var item: WorkCellProvider? {
        didSet {
            
            lblTitle.text = /item?.property?.model?.option_name
            btnSelected.isSelected = /item?.property?.model?.isSelected
        }
    }
}
