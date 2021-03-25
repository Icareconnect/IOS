//
//  ProfileVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 02/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class ProfileVC: BaseVC {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblVersionNo: UILabel!
    @IBOutlet weak var lblVersionInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var headerView: UIView!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<ProfileItem>, DefaultCellModel<ProfileItem>, ProfileItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(viewProfile)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateProfileData()
    }
}

//MARK:- VCFuncs
extension ProfileVC {
    @objc private func viewProfile() {
        pushVC(Storyboard<ProfileDetailVC>.Other.instantiateVC())
    }
    
    public func updateProfileData() {
        tableView.tableHeaderView = headerView
        lblName.text = UserPreference.shared.data?.name == "1#123@123" ? "" : UserPreference.shared.data?.name
        var age = VCLiteral.NA.localized
        if /UserPreference.shared.data?.profile?.dob != "" {
            age = "\(Date().year() - /Date.init(fromString: /UserPreference.shared.data?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).year())"
        }
        lblAge.text = String.init(format: VCLiteral.AGE.localized, age)
        imgView.setImageNuke(/UserPreference.shared.data?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.PROFILE.localized
        lblVersionNo.text = String.init(format: VCLiteral.VERSION.localized, Bundle.main.versionNumber)
        lblVersionInfo.text = VCLiteral.VERSION_INFO.localized
        tableView.contentInset.top = 16.0
        dataSource = TableDataSource<DefaultHeaderFooterModel<ProfileItem>, DefaultCellModel<ProfileItem>, ProfileItem>.init(.SingleListing(items: ProfileItem.getItems(pages: UserPreference.shared.pages), identifier: SideMenuCell.identfier, height: 56.0, leadingSwipe: nil, trailingSwipe: nil), tableView)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? SideMenuCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            switch item?.property?.model?.title ?? .AGE {
            case .CHAT:
                self?.pushVC(Storyboard<ChatListingVC>.Other.instantiateVC())
            case .CLASSES:
                let destVC = Storyboard<ClassesVC>.Other.instantiateVC()
                self?.pushVC(destVC)
            case .NOTIFICATIONS:
                self?.pushVC(Storyboard<NotificationsVC>.Other.instantiateVC())
            case .INVITE_PEOPLE:
//                let appLink = "https://apps.apple.com/us/app/id\(Constants.APPLE_APP_ID.rawValue)?ls=1"
//                self?.share(items: [appLink], sourceView: self?.tableView.cellForRow(at: indexPath))
                
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
                
                shareLink.shorten { [weak self] (url, warnings, error) in
                    self?.share(items: [/url?.absoluteString], sourceView: self?.tableView.cellForRow(at: indexPath))
                }
                
            case .LOGOUT:
                self?.logoutAlert()
            default:
                let destVC = Storyboard<WebLinkVC>.Other.instantiateVC()
                destVC.linkTitle = (/UserPreference.shared.clientDetail?.domain_url + /item?.property?.model?.page?.slug, /item?.property?.model?.page?.title)
                self?.pushVC(destVC)
            }
        }
    }
    
    private func logoutAlert() {
        alertBoxOKCancel(title: VCLiteral.LOGOUT.localized, message: VCLiteral.LOGOUT_ALERT_MESSAGE.localized, tapped: { [weak self] in
            self?.logoutAPI()
        }, cancelTapped: nil)
    }
    
    private func logoutAPI() {
        playLineAnimation()
        EP_Home.logout.request(success: { [weak self] (_) in
            self?.stopLineAnimation()
            UIWindow.replaceRootVC(Storyboard<LoginSignUpNavVC>.LoginSignUp.instantiateVC())
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
}
