//
//  AppointmentCell.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 01/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit


import UIKit

class AppointmentCell: UITableViewCell, ReusableCell {
    
//    typealias T = HomeCellProvider
    typealias T = DefaultCellModel<Requests>

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRequestType: UILabel!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblbookingDates: UILabel!
    
    var reloadTable: (() -> Void)?
    var item: DefaultCellModel<Requests>? {

//    var item: HomeCellProvider? {
        didSet {
            let obj = item?.property?.model//?.request
            lblName.text = /obj?.from_user?.name
            lblRequestType.text = (/obj?.service_type).uppercased()
//            lblStatus.text = /obj?.status?.title.localized
            if /obj?.status?.title.localized == VCLiteral.CANCELLED.localized {
                
                if /obj?.canceled_by?.id != /UserPreference.shared.data?.id {
                    lblStatus.text = "CANCELLED"//obj?.status?.title.localized
                } else {
                    lblStatus.text = "DECLINED"///obj?.status?.title.localized
                }
                    
            } else {
                lblStatus.text = /obj?.status?.title.localized
            }
            
            imgVIew.setImageNuke(/obj?.from_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            let utcDate = Date(fromString: /obj?.created_at, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            lblDate.text = utcDate.toString(DateFormat.custom("dd MMM yyyy · hh:mm a"), timeZone: .local)
            lblAddress.text = /obj?.extra_detail?.service_address
            lblDistance.text = /obj?.extra_detail?.distance
            lblTime.text = "\(/obj?.extra_detail?.start_time) - \(/obj?.extra_detail?.end_time)"
            lblRequestType.text = /obj?.extra_detail?.filter_name
            
            let dates = /obj?.extra_detail?.working_dates
            let datesArr = dates.components(separatedBy: ",")

            var localArr = [String]()
            for dateStr in datesArr {
                let utcDate1 = Date(fromString: dateStr, format: DateFormat.custom("yyyy-MM-dd"), timeZone: .local)
                localArr.append(utcDate1.toString(DateFormat.custom("dd MMM yyyy"), timeZone: .local))
            }
            
            lblbookingDates.text = localArr.joined(separator: " | ")
            lblStatus.textColor = obj?.status?.linkedColor.color

//            switch obj?.status ?? .unknown {
//            case .canceled, .failed:
//                lblStatus.textColor = ColorAsset.requestStatusFailed.color
//            case .pending:
//                lblStatus.textColor = ColorAsset.requestHome.color
//            case .accept, .completed, .start_service:
//                lblStatus.textColor = ColorAsset.requestHome.color
//            default:
//                break
//            }
            
            /*

            lblPrice.text = /obj?.price?.toDouble()?.getFormattedPrice()
            btnCancel.isHidden = !(/obj?.canCancel)
            btnCancel.setTitle(VCLiteral.CANCEL.localized, for: .normal)
            
            switch obj?.status ?? .unknown {
            case .canceled, .completed, .failed:
                btnCancel.isHidden = true
                btnMulti.isHidden = true
            case .pending:
                btnMulti.isHidden = false
                btnMulti.setTitle(VCLiteral.ACCEPT_TITLE.localized, for: .normal)
            case .accept:
                btnMulti.isHidden = false
                btnMulti.setTitle(VCLiteral.START.localized, for: .normal)
            default:
                btnMulti.isHidden = true
            }
 */
        }
    }
    
}
