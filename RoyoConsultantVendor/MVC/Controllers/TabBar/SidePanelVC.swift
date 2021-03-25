//
//  SidePanelVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class SidePanelVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<SideMenueItem>, DefaultCellModel<SideMenueItem>, SideMenueItem>?
    private var collectionDataSource: CollectionDataSource?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()
        setProfileData()
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        toggleSideMenuView()
        UIApplication.topVC()?.pushVC(Storyboard<ProfileDetailVC>.Other.instantiateVC())
    }
    
}

//MARK:- VCFuncs
extension SidePanelVC {
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<SideMenueItem>, DefaultCellModel<SideMenueItem>, SideMenueItem>.init(.SingleListing(items: SideMenueItem.getArray(), identifier: SidePanelCell.identfier, height: 56, leadingSwipe: nil, trailingSwipe: nil), tableView)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? SidePanelCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            self?.toggleSideMenuView()
            switch (item?.property?.model?.title ?? .NOTIFICATIONS) {
            case .PROFILE:
                UIApplication.topVC()?.pushVC(Storyboard<ProfileDetailVC>.Other.instantiateVC())

            case .MANAGE_DOCUMENTS:
                
                let destVC = Storyboard<UploadDocsVC>.LoginSignUp.instantiateVC()
                destVC.isUpdating = true
                UIApplication.topVC()?.pushVC(destVC)

            case .REVENUE:
                let destVC = Storyboard<RevenueVC>.TabBar.instantiateVC()
                UIApplication.topVC()?.pushVC(destVC)
                
            case .NOTIFICATIONS:
                UIApplication.topVC()?.pushVC(Storyboard<NotificationsVC>.Other.instantiateVC())
            case .CHAT:
                UIApplication.topVC()?.pushVC(Storyboard<ChatListingVC>.Other.instantiateVC())
            case .SHARE_APP:
                
                let appLink = "\(BasePath.Developement.rawValue)\(DynamicLinkPage.Invite.rawValue)"
                
                guard let shareLink = DynamicLinkComponents.init(link: URL.init(string: appLink)!, domainURIPrefix: "https://\(Constants.PageLink.rawValue)") else {
                    return
                }
                
                shareLink.iOSParameters = DynamicLinkIOSParameters.init(bundleID: /Bundle.main.bundleIdentifier)
                shareLink.iOSParameters?.appStoreID = Constants.APPLE_APP_ID.rawValue
                shareLink.androidParameters = DynamicLinkAndroidParameters.init(packageName: Constants.ANDROID_PACKAGE_NAME.rawValue)
                shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
                shareLink.socialMetaTagParameters?.title = Bundle.main.infoDictionary?["CFBundleName"] as? String
                shareLink.socialMetaTagParameters?.descriptionText = VCLiteral.APP_DESC.localized
                shareLink.socialMetaTagParameters?.imageURL = URL.init(string: ImageBasePath.upload.url + /UserPreference.shared.clientDetail?.applogo)
                
                shareLink.shorten { (url, warnings, error) in
                    UIApplication.topVC()?.share(items: [/url?.absoluteString], sourceView: nil)
                }
            
            case .SIGN_OUT:
                self?.logoutAlert()
            case .FAVOURITES:
                UIApplication.topVC()?.pushVC(Storyboard<FavouritesVC>.Other.instantiateVC())
            case .CONTACT_US:
                let destVC = Storyboard<WebLinkVC>.Other.instantiateVC()
                destVC.linkTitle = (/UserPreference.shared.clientDetail?.domain_url + "/contact-us", "Contact Us")
                UIApplication.topVC()?.pushVC(destVC)
                
                break
            case .MY_BLOGS:
                let destVC = Storyboard<BlogArticleListingVC>.Other.instantiateVC()
                destVC.feedType = .blog
                destVC.isMine = true
                UIApplication.topVC()?.pushVC(destVC)
            case .ACCOUNT_DETAILS:
                UIApplication.topVC()?.pushVC(Storyboard<PayOutVC>.Other.instantiateVC())
            case .CHANEG_PASSWORD:
                UIApplication.topVC()?.pushVC(Storyboard<ChangePasswordVC>.Other.instantiateVC())
            default:
                break
            }
        }
    }
    
    private func logoutAlert() {
        alertBoxOKCancel(title: VCLiteral.LOGOUT.localized, message: VCLiteral.LOGOUT_ALERT_MESSAGE.localized, tapped: { [weak self] in
            self?.logoutAPI()
        }, cancelTapped: nil)
    }
    
    private func logoutAPI() {
        (UIApplication.topVC() as? BaseVC)?.playLineAnimation()
        EP_Home.logout.request(success: { (_) in
            (UIApplication.topVC() as? BaseVC)?.stopLineAnimation()
            UIWindow.replaceRootVC(Storyboard<LoginSignUpNavVC>.LoginSignUp.instantiateVC())
        }) { (_) in
            (UIApplication.topVC() as? BaseVC)?.stopLineAnimation()
        }
    }
    
    public func setProfileData() {
        imgView.setImageNuke(/UserPreference.shared.data?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        lblName.text = UserPreference.shared.data?.name == "1#123@123" ? "" : UserPreference.shared.data?.name
    }
}
