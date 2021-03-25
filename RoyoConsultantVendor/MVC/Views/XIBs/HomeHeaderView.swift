//
//  HomeHeaderView.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 07/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeHeaderView: UITableViewHeaderFooterView, ReusableHeaderFooter {
    
    typealias T = HomeSectionProvider
    
    @IBOutlet weak var lblTItleRegular: UILabel!
    @IBOutlet weak var lblTitleBold: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    var didTapBtn: ((_ _actionType: HeaderActionType?) -> Void)?
    
    var item: HomeSectionProvider? {
        didSet {
            lblTItleRegular.text = /item?.headerProperty?.model?.titleRegular?.localized
            lblTitleBold.text = /item?.headerProperty?.model?.titleBold?.localized
            lblTItleRegular.isHidden = /item?.headerProperty?.model?.titleRegular?.localized == ""
            btn.setTitle(/item?.headerProperty?.model?.btnText?.localized, for: .normal)
            btn.isHidden = /item?.headerProperty?.model?.isBtnHidden
        }
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        didTapBtn?(item?.headerProperty?.model?.action)
    }
}
 
