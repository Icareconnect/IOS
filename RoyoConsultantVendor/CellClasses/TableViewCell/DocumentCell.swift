//
//  DocumentCell.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 04/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
enum DocCellBtnType {
    case Delete
    case Edit
    case Add
}

class DocumentCell: UITableViewCell, ReusableCell {
    
    typealias T = DocCellProvider

    @IBOutlet weak var lblStatus: UILabel!

    @IBOutlet weak var lblDocTitle: UILabel!
    @IBOutlet weak var lblDocDesc: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!

    var didTapFor: ((_ _type: DocCellBtnType) -> Void)?
    
    var item: DocCellProvider? {
        didSet {
            lblDocTitle.text = /item?.property?.model?.title
            lblDocDesc.text = /item?.property?.model?.description
            btnDelete.isHidden = false
            btnEdit.isHidden = false

            if /item?.property?.model?.title == "" {
                btnAdd.isHidden = false
                btnEdit.isHidden = true
                btnDelete.isHidden = true

            } else {
                btnEdit.isHidden = false
                btnDelete.isHidden = false
                btnAdd.isHidden = true

            }
            switch item?.property?.model?.status {
            case .in_progress:
                lblStatus.text = VCLiteral.in_progress.localized
                lblStatus.textColor = ColorAsset.txtLightGrey.color
            case .approved:
                lblStatus.text = VCLiteral.approved.localized
                lblStatus.textColor = ColorAsset.appTint.color
                btnDelete.isHidden = true
                btnEdit.isHidden = true
            case .declined:
                lblStatus.text = VCLiteral.declined.localized
                lblStatus.textColor = ColorAsset.requestStatusFailed.color

            default:
                lblStatus.text = ""
            }
            
            switch /item?.property?.model?.type {
            case MediaTypeUpload.image.rawValue:
                imgView.setImageNuke(/item?.property?.model?.file_name)
                imgView.contentMode = .scaleAspectFill
            case MediaTypeUpload.pdf.rawValue:
                imgView.image = UIImage.init(named: "ic_file")
                imgView.contentMode = .scaleAspectFit
            default:
                break
            }
            
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Delete
            didTapFor?(.Delete)
        case 1: //Edit
            didTapFor?(.Edit)
        case 2: //Add
            didTapFor?(.Add)
        default:
            break
        }
    }
    
}
