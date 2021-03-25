//
//  TabVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 27/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

import UIKit

class TabVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            // ios 13.0 and above
            let appearance = tabBar.standardAppearance
            appearance.shadowColor = nil
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            
            tabBar.standardAppearance = appearance
        } else {
            // below ios 13.0
            let image = UIImage()
            tabBar.shadowImage = image
            tabBar.backgroundImage = image
            // background
            
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)], for: .selected)
        tabBar.layer.shadowColor = ColorAsset.shadow.color.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.masksToBounds = false
        tabBar.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if /UserPreference.shared.firebaseToken == "" {
            return
        }
        EP_Home.updateFCMId.request(success: { (_) in
            
        })
    }
    
}
