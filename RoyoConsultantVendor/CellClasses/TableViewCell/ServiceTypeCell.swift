//
//  ServiceTypeCell.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 30/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ServiceTypeCell: UITableViewCell, ReusableCell {
    
    typealias T = ServiceCellProvider
    
    @IBOutlet weak var lblFeeTitle: UILabel!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var lblPriceType: UILabel!
    @IBOutlet weak var tfFee: UITextField!
    @IBOutlet weak var tfFor: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var btnAddEditAvailability: UIButton!
    
    var categoryId: String?
    
    var item: ServiceCellProvider? {
        didSet  {
            let service = item?.property?.model?.service
            lblFeeTitle.text = VCLiteral.CONSULTATION_FEE.localized
            lblForTitle.text = VCLiteral.FOR_UNIT.localized
            btnAddEditAvailability.setTitle(/item?.property?.model?.type?.addAvailabilityTitle.localized, for: .normal)
            lblCurrency.text = UserPreference.shared.getCurrencyAbbr()
            lblPriceType.text = /service?.price_type?.getRelatedText(model: service)
            btnAddEditAvailability.isHidden = /(service?.need_availability == .FALSE)
            tfFee.isUserInteractionEnabled = service?.price_type == .price_range
            tfFor.isUserInteractionEnabled = false
            tfFor.text = "\(UserPreference.shared.getCurrencyAbbr()) / \(getUnit(/Int(/service?.unit_price)))"
            tfFee.text = service?.price_type == .price_range ? (/service?.price == 0.0 ? "" : /String(/service?.price)) : String(/service?.price_fixed)
        }
    }
    
    @IBAction func btnAddEditAvailabilityAction(_ sender: UIButton) {
        let destVC = Storyboard<SelectAvailabilityVC>.LoginSignUp.instantiateVC()
        if item?.property?.model?.type == .WhileManaging {
            item?.property?.model?.timeSlots = [TimeSlot]()
        }
        destVC.categoryID = categoryId
        destVC.serviceCustom = item?.property?.model
        destVC.didAddedAvailability = { [weak self] (model) in
            self?.item?.property?.model = model
        }
        UIApplication.topVC()?.pushVC(destVC)
    }
    
    @IBAction func tfFeeTextCahnged(_ sender: UITextField) {
        item?.property?.model?.service?.price = /sender.text?.toDouble()
    }
    
    @IBAction func tfForTextChanged(_ sender: UITextField) {
        
    }
    
    func getUnit(_ seconds: Int) -> String {
        if seconds == 60 {
            return VCLiteral.MINUTE.localized
        } else if seconds == 1 {
            return VCLiteral.SECOND.localized
        } else if seconds > 3600 && seconds < 7200 {
            return VCLiteral.HOUR.localized
        } else if seconds < 60 {
            return String.init(format: VCLiteral.SECONDS.localized, "\(seconds)")
        } else if seconds >= 3600 {
            return String.init(format: VCLiteral.HOURS.localized, "\(seconds / 60)")
        } else {
            return String.init(format: VCLiteral.MINUTES.localized, "\(seconds / 60)")
        }
    }
}
