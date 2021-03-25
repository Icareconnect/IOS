//
//  ProfileItem.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 02/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ProfileItem {
    var title: VCLiteral?
    var image: UIImage?
    var page: Page?

    init(_ _title: VCLiteral, _ _image: UIImage?) {
        title = _title
        image = _image
    }
    
    init(_ _page: Page?, _image: UIImage?) {
        page = _page
        image = _image
    }
    
    class func getItems(pages: [Page]?) -> [ProfileItem] {
        
//        ProfileItem.init(.CONTACT_US, #imageLiteral(resourceName: "ic_contact_drawer")),
//        ProfileItem.init(.TERMS_AND_CONDITIONS, #imageLiteral(resourceName: "ic_terms")),
//        ProfileItem.init(.ABOUT, #imageLiteral(resourceName: "ic_info")),
        
        var items = [ProfileItem.init(.CHAT, #imageLiteral(resourceName: "ic_chat_profile")),
                     ProfileItem.init(.CLASSES, #imageLiteral(resourceName: "ic_class_profile")),
                     ProfileItem.init(.NOTIFICATIONS, #imageLiteral(resourceName: "ic_notification_drawer")),
                     ProfileItem.init(.INVITE_PEOPLE, #imageLiteral(resourceName: "ic_invite_drawer"))]
        
        pages?.forEach({ items.append(ProfileItem.init($0, _image: #imageLiteral(resourceName: "ic_info")))})

        
        return items + [ProfileItem.init(.LOGOUT, #imageLiteral(resourceName: "ic_logout"))]
    }

}
