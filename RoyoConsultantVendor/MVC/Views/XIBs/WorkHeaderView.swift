//
//  DocHeaderView.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 04/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class WorkHeaderView: UITableViewHeaderFooterView, ReusableHeaderFooter {
    typealias T = WorkHeaderProvider
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    var didTapSelectAll: (() -> Void)?
    
    var item: WorkHeaderProvider? {
        didSet {
            lblTitle.text = /item?.headerProperty?.model?.preference_name
            btnAdd.setTitle(VCLiteral.SELECT_ALL.localized, for: .normal)
            btnAdd.isSelected = /item?.headerProperty?.model?.isSelectedAll
        }
    }
    
    @IBAction func btnAddAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        didTapSelectAll?()
    }
    
}
