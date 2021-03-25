//
//  ProfileDetailVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 03/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ProfileDetailVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblExpEtc: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRatingReviews: UILabel!
    @IBOutlet weak var lblClientTitle: UILabel!
    @IBOutlet weak var lblClientCount: UILabel!
    @IBOutlet weak var lblExpTitle: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var lblReviewTitle: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var btnManageAvailability: UIButton!
    @IBOutlet weak var btnManagePreferences: UIButton!
    @IBOutlet weak var btnUpdateCategory: UIButton!
    @IBOutlet weak var lblBioTitle: UILabel!
    @IBOutlet weak var lblBioValue: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblEmailValue: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPhoneValue: UILabel!
    @IBOutlet weak var vwClientDetails: UIView!
//    @IBOutlet weak var lblDOB: UILabel!
//    @IBOutlet weak var lblDOBValue: UILabel!
    
    @IBOutlet weak var lblPersonalInterestValue: UILabel!
    @IBOutlet weak var lblWorkEnvironmentValue: UILabel!
    @IBOutlet weak var lblCovidValue: UILabel!
    @IBOutlet weak var lblServicesValue: UILabel!

    
    @IBOutlet weak var lblPersonalInterest: UILabel!
    @IBOutlet weak var lblWorkEnvironment: UILabel!
    @IBOutlet weak var lblCovid: UILabel!
    @IBOutlet weak var lblServices: UILabel!

    @IBOutlet weak var switchAvailability: UISwitch!
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var switchShift: UISwitch!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.getVendorDetailAPI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        localizedTextSetup()
        updateProfileData(user: UserPreference.shared.data)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Edit Profile

            let destVC = Storyboard<SetupProfileVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging
            pushVC(destVC)
//
//            let destVC = Storyboard<CovidFormVC>.LoginSignUp.instantiateVC()
//            destVC.modalPresentationStyle = .overFullScreen
//            pushVC(destVC)
        
        case 2: //Manage Availability
            let destVC = Storyboard<ServicesVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging
            pushVC(destVC)
        case 3: //Manage Preferences
            let destVC = Storyboard<SetPreferencesVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging
            destVC.isUpdatingFiltersOnly = true
            pushVC(destVC)
        case 4: //Update Category
            let destVC = Storyboard<CategoriesVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging
            pushVC(destVC)
        case 5://Update Providable Services
            let destVC = Storyboard<ProvidableServicesVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging
            pushVC(destVC)
        case 6://Update Work Environment
            let destVC = Storyboard<WorkEnvironmentVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging
            pushVC(destVC)
            
        case 7://Update Covid Environment
            let destVC = Storyboard<CovidFormVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging
            pushVC(destVC)
        case 8:// Providable Services
            let destVC = Storyboard<PersonalInterestVC>.LoginSignUp.instantiateVC()
            destVC.comingFrom = .WhileManaging

            self.pushVC(destVC)

        default:
            break
        }
    }
    
    @IBAction func actionSwitch(_ sender: UISwitch) {
        
        self.playLineAnimation()
        switch sender.tag {
        case 0://Availability
            EP_Login.setManualAvailability(manual_available: sender.isOn, premium_enable: nil, notification_enable: nil).request(success: { [weak self] (responseData) in
                self?.stopLineAnimation()
            }) { [weak self] (_) in
                self?.stopLineAnimation()
            }
        case 1: // Notification
            EP_Login.setManualAvailability(manual_available: nil, premium_enable: nil, notification_enable: sender.isOn).request(success: { [weak self] (responseData) in
                self?.stopLineAnimation()
            }) { [weak self] (_) in
                self?.stopLineAnimation()
            }
        case 2://Premium Shift
            EP_Login.setManualAvailability(manual_available: nil, premium_enable: sender.isOn, notification_enable: nil).request(success: { [weak self] (responseData) in
                self?.stopLineAnimation()
            }) { [weak self] (_) in
                self?.stopLineAnimation()
            }
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension ProfileDetailVC {
    
    private func getVendorDetailAPI() {
        playLineAnimation()
        EP_Home.vendorDetail(vendorId: String(/UserPreference.shared.data?.id)).request(success: { [weak self] (responseData) in
            self?.updateProfileData(user: responseData as? User)
            self?.stopLineAnimation()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.PROFILE.localized
        btnEdit.setTitle(VCLiteral.EDIT_CAPS.localized, for: .normal)
        lblClientTitle.text = VCLiteral.CLIENTS_TITLE.localized
        lblExpTitle.text = VCLiteral.EXPERIENCE.localized
        lblReviewTitle.text = VCLiteral.REVIEWS.localized
        btnManageAvailability.setTitle(VCLiteral.Availability.localized, for: .normal)
        btnManagePreferences.setTitle(VCLiteral.NOTIFICATIONS.localized, for: .normal)
        btnUpdateCategory.setTitle(VCLiteral.Premium_shift.localized, for: .normal)
        lblBioTitle.text = VCLiteral.PERSONAL_PROFILE.localized
        lblEmail.text = VCLiteral.EMAIL_PLACEHOLDER.localized
        lblPhone.text = VCLiteral.PHONE_NUMBER.localized
        
        lblPersonalInterestValue.text = VCLiteral.PersoanlInterest.localized
        lblCovidValue.text = VCLiteral.Covid.localized
        lblWorkEnvironmentValue.text = VCLiteral.WorkEnvironment.localized
        lblServicesValue.text = VCLiteral.ProvidableServices.localized
        
        btnManagePreferences.isHidden = /UserPreference.shared.data?.filters?.count == 0
        
    }
    
    private func updateProfileData(user: User?) {
        imgView.setImageNuke(/user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        lblName.text = /user?.name
        
//        let experience = "\(Date().year() - /Date.init(fromString: /user?.profile?.working_since, format: DateFormat.custom("yyyy-MM-dd")).year())".experience
        let experience = /user?.custom_fields?.first(where: {/$0.field_name == "Work experience"})?.field_value

        var desc = [/*/user?.qualification, /user?.speciality,*/experience]
        desc.removeAll(where: {/$0 == ""})
        lblExpEtc.text = desc.joined(separator: " · ")
        
        lblExpEtc.text = VCLiteral.APPROVED.localized + ": " + Date.init(fromString: /user?.account_verified_at, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss")).toString(DateFormat.custom("MMM dd, yyyy"), timeZone: .local)

        lblAddress.text = VCLiteral.NA.localized
        if let filters = user?.filters, filters.count > 0 {
            if let options = filters[0].options {
                
                let filterTitle = (options.filter({ /$0.isSelected }).compactMap( { $0.option_name } ))
                
                lblAddress.text = filterTitle.joined(separator: ", ")
            }
        }
        
//        lblAddress.text = user?.address ?? VCLiteral.NA.localized
        lblRatingReviews.text = "\(/user?.totalRating) · \(/user?.reviewCount) \(/user?.reviewCount == 1 ? VCLiteral.REVIEW.localized : VCLiteral.REVIEWS.localized)"
        lblClientCount.text = "\(/user?.patientCount)"
        lblExp.text = experience
        lblReviewCount.text = "\(/user?.reviewCount)"
        lblBioValue.text = /user?.profile?.bio
        lblEmailValue.text = /user?.email
        lblPhoneValue.text = "\(/user?.country_code) \(/user?.phone)"
//        lblDOB.text = Date.init(fromString: /user?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom("MMM dd, yyyy"), timeZone: .local)
        
        switchShift.isOn = /user?.premium_enable
        switchAvailability.isOn = /user?.manual_available
        switchNotification.isOn = /user?.notification_enable
        
        
        var workArr = [Preference]()
        var personalInterestArr = [Preference]()
        var covidArr = [Preference]()
        var servicesArr = [Preference]()

        for item in user?.master_preferences ?? [] {
            
            switch /item.preference_type {
            case "work_environment", "Hospital", "Service Location /Conditions":
                workArr.append(item)
            case "personal_interest":
                personalInterestArr.append(item)
            case "covid":
                covidArr.append(item)
            case "duty":
                servicesArr.append(item)
            default:
                break
            }
        }
        
        var workTitle = [String]()
        workArr.forEach { (work) in
            if let options = work.options {
                options.map({ /$0.option_name }).forEach { (op) in
                    workTitle.append(op)
                }
            }
        }
        lblWorkEnvironment.text = workTitle.joined(separator: ", ")
        
        if personalInterestArr.count > 0 {
            if let options = personalInterestArr[0].options {
                let filterTitle = options.map({ /$0.option_name })
                
                lblPersonalInterest.text = filterTitle.joined(separator: ", ")
            }
        }
        
        if servicesArr.count > 0 {
            if let options = servicesArr[0].options {
                let filterTitle = options.map({ /$0.option_name })
                
                lblServices.text = filterTitle.joined(separator: ", ")
            }
        }
        
        var covidStrArr = [String]()
        for item in covidArr {
            
            if let options = item.options {
                let filterTitle = options.map({ /$0.option_name })
                
                covidStrArr.append("\(/item.preference_name)\n\(filterTitle.joined(separator: ", "))\n\n")
            }
        }
        lblCovid.text = covidStrArr.joined(separator: "")
    }
}

