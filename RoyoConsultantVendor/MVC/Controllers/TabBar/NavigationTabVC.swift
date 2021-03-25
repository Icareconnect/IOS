//
//  SideMenuNavVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class NavigationTabVC: ENSideMenuNavigationController {
    
    let menuVC = Storyboard<SidePanelVC>.TabBar.instantiateVC()
    let overlayView = UIVisualEffectView.init(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu = ENSideMenu.init(sourceView: self.view, menuViewController: menuVC, menuPosition: .left)
        overlayView.effect = UIBlurEffect(style: .systemUltraThinMaterial)
        sideMenu?.menuWidth = UIScreen.main.bounds.width * 0.7
        sideMenu?.delegate = self
        sideMenu?.bouncingEnabled = false
        sideMenu?.allowPanGesture = true
        sideMenu?.allowLeftSwipe = false
        sideMenu?.allowRightSwipe = false
        view.bringSubviewToFront(overlayView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        overlayView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender : UITapGestureRecognizer){
         toggleSideMenuView()
     }
}

//MARK:- ENSideMenuDelegate
extension NavigationTabVC: ENSideMenuDelegate {
    func sideMenuWillOpen() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) { [ weak self] in
            self?.menuVC.setProfileData()
            self?.topViewController?.view.addSubview(self?.overlayView ?? UIView())
        }
    }
    
    func sideMenuWillClose() {
        UIView.animate(withDuration: 0.4) { [ weak self ] in
            self?.overlayView.removeFromSuperview()
        }
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    
    func sideMenuDidOpen() {
        
    }
    
    func sideMenuDidClose() {
        
    }
}
