//
//  VerificationPendingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VerificationPendingVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = VCLiteral.VERIFICATION_PENDING_TITLE.localized
        lblDesc.text = VCLiteral.VERIFICATION_PENDING_DESC.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getVendorDetailAPI()
    }
    @IBAction func actionManage(_ sender: Any) {
        
        let destVC = Storyboard<UploadDocsVC>.LoginSignUp.instantiateVC()
        destVC.isUpdating = true
        UIApplication.topVC()?.pushVC(destVC)

    }
    
    public func getVendorDetailAPI() {
        playLineAnimation()
        EP_Login.profileUpdate(name: nil, email: nil, phone: nil, country_code: nil, dob: nil, bio: nil, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: nil, workingSince: nil, namePrefix: nil, custom_fields: nil, master_preferences: nil, address: nil, lat: nil, long: nil).request(success: { [weak self] (responseData) in
            
            UserPreference.shared.data = responseData as? User
            if /UserPreference.shared.data?.account_verified {
                self?.popVC()
            }
            self?.stopLineAnimation()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
}
