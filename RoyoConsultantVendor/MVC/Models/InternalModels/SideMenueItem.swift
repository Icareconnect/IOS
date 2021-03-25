//
//  SideMenueItem.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 24/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SideMenueItem {
    var title: VCLiteral?
    var image: UIImage?
    
    init(_ _title: VCLiteral, _ _image: UIImage) {
        title = _title
        image = _image
    }
    
    class func getArray() -> [SideMenueItem] {
        var items = [SideMenueItem]()
        items = [SideMenueItem(.PROFILE, #imageLiteral(resourceName: "ic-profile")),
                 SideMenueItem(.MANAGE_DOCUMENTS, #imageLiteral(resourceName: "ic-manage-doc"))]
        
        //                 SideMenueItem(.LOGS, #imageLiteral(resourceName: "ic_1")),
        
        if UserPreference.shared.data?.provider_type == ProviderType.email {
            items.append(SideMenueItem(.CHANEG_PASSWORD, #imageLiteral(resourceName: "ic-password")))
        }
        let page = [SideMenueItem(.CONTACT_US, #imageLiteral(resourceName: "ic-contactUs")),
                    SideMenueItem(.ACCOUNT_DETAILS, #imageLiteral(resourceName: "ic-accountdetails")),
                    //                 SideMenueItem(.CHANGE_ADDRESS, #imageLiteral(resourceName: "ic_1")),
                    SideMenueItem(.REVENUE, #imageLiteral(resourceName: "ic-earning")),
                    //                SideMenueItem(.FAVOURITES, #imageLiteral(resourceName: "ic_like_unselected")),
                    //                SideMenueItem(.MY_BLOGS, #imageLiteral(resourceName: "ic_my article")),
                    //                SideMenueItem(.CHAT, #imageLiteral(resourceName: "ic_10")),
                    //                SideMenueItem(.HELP_SUPPORT, #imageLiteral(resourceName: "ic_20")),
                    SideMenueItem(.SHARE_APP, #imageLiteral(resourceName: "ic_11")),
                    SideMenueItem(.SIGN_OUT, #imageLiteral(resourceName: "ic_21"))]
        
        
        for inte in page {
            items.append(inte)
        }
//        page.forEach({ items.append(SideMenueItem.init($0, _image: #imageLiteral(resourceName: "ic_info")))})
        
        return items
    }
}
