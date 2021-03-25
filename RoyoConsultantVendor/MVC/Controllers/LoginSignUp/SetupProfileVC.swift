//
//  SetupProfileVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 14/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import GooglePlaces

class SetupProfileVC: BaseVC {
    
    @IBOutlet weak var tfCertification: UITextField!
    @IBOutlet weak var tfLicense: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPersonalProfile: UITextField!
    @IBOutlet weak var btnContinue: SKLottieButton!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var tfMobileNumber: UITextField!

    @IBOutlet weak var vwMobile: UIView!
    @IBOutlet weak var vwEmail: UIView!

    @IBOutlet weak var btnNightShift: UIButton!
    @IBOutlet weak var btnDayShift: UIButton!
    @IBOutlet weak var btnEveningShift: UIButton!
    @IBOutlet weak var btnWeekend: UIButton!
    @IBOutlet weak var btnLiveIn: UIButton!
    
    @IBOutlet weak var btn0Months: UIButton!
    @IBOutlet weak var btn6Months: UIButton!
    @IBOutlet weak var btn12Months: UIButton!
    @IBOutlet weak var btn24Months: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleDescription: UILabel!
    @IBOutlet weak var lblQualififcationTypeText: UILabel!
//    @IBOutlet weak var lblSelectText: UILabel!
//    @IBOutlet weak var lblShiftInterestedText: UILabel!

    @IBOutlet weak var cnstTableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var imgView: UIImageView!

    private var image_URL: String?
    public var comingFrom: AvailabilityDataType = .WhileLoginModule

    private var dataSource: TableDataSource<DefaultHeaderFooterModel<FilterOption>, DefaultCellModel<FilterOption>, FilterOption>?
    private var categories = [FilterOption]()
    private var workingSince: Date?
    private var selectedShift: String?
    private var currentLat: String?
    private var currentLong: String?
    
    private var resultsViewController: GMSAutocompleteResultsViewController?
    private var searchController: UISearchController?
    private var countryPicker: CountryManager?
    private var currentCountry: CountryISO?

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizeTextSetup()
        setUpView()
    }
    
    //MARK: - IBActions
    @IBAction func backAction(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func actionContinue(_ sender: Any) {

        var isOneSelected = false
        categories.forEach({ if ($0.isSelected == true) {
            isOneSelected = true
        }
        })
        
        if !isOneSelected {
            Toast.shared.showAlert(type: .validationFailure, message: "Please choose qualification type")
        } else if /tfName.text?.isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: "Please enter your name")
        } else if /tfPersonalProfile.text?.isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: "Please enter your personal profile")
        } else if /tfAddress.text?.isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: "Please choose your address")
        }
//        else if /tfLicense.text?.isEmpty {
//            Toast.shared.showAlert(type: .validationFailure, message: "Please enter your Professional License #")
//        }
        else if /tfDate.text?.isEmpty {
            Toast.shared.showAlert(type: .validationFailure, message: "Please select start date")
        } else if !btnWeekend.isSelected && !btnLiveIn.isSelected && !btnDayShift.isSelected && !btnEveningShift.isSelected && !btnNightShift.isSelected {
           
            Toast.shared.showAlert(type: .validationFailure, message: "Please select your shift preferences")
        } else if !btn0Months.isSelected && !btn6Months.isSelected && !btn12Months.isSelected && !btn24Months.isSelected {
            
            Toast.shared.showAlert(type: .validationFailure, message: "Please select your license experince")
        } else {
            
            uploadData()
        }
    }
    
    @IBAction func actionUploadImage(_ sender: Any) {
        selectImage()
    }
    @IBAction func actionAddress(_ sender: Any) {
        addPlacePicker()
    }
    
    @IBAction func actionExperience(_ sender: UIButton) {
        btn0Months.isSelected = false
        btn6Months.isSelected = false
        btn24Months.isSelected = false
        btn12Months.isSelected = false
        
        sender.isSelected = true
        selectedShift = /sender.titleLabel?.text
    }
    
    @IBAction func actionShifts(_ sender: UIButton) {
        
        switch sender {
        case btnNightShift:
            btnNightShift.isSelected = !btnNightShift.isSelected
        case btnDayShift:
            btnDayShift.isSelected = !btnDayShift.isSelected
        case btnEveningShift:
            btnEveningShift.isSelected = !btnEveningShift.isSelected
        case btnWeekend:
            btnWeekend.isSelected = !btnWeekend.isSelected
        case btnLiveIn:
            btnLiveIn.isSelected = !btnLiveIn.isSelected
            
        default:
            break
        }
    }
}
extension SetupProfileVC {
    
    func localizeTextSetup() {
        
        if comingFrom == .WhileManaging {
            
            lblTitle.text = VCLiteral.UPDATE.localized
            lblTitleDescription.text = ""
        } else {
            
            lblTitle.text = VCLiteral.Registration.localized
            lblTitleDescription.text = VCLiteral.BECOME_MEMBER.localized
        }
        
        tfName.placeholder = VCLiteral.FULL_NAME.localized
        tfAddress.placeholder = VCLiteral.ADDRESS.localized
        tfPersonalProfile.placeholder = VCLiteral.PERSONAL_PROFILE.localized
        lblQualififcationTypeText.text = VCLiteral.SET_QUALIFICATION.localized
//        lblSelectText.text = VCLiteral.CAN_SELECT.localized
//        lblShiftInterestedText.text = VCLiteral.SHIFT_INTERESTED.localized
        
        tfMobileNumber.placeholder = VCLiteral.MOBILE_PACEHOLDER.localized
        lblCountryCode.text = "\(/currentCountry?.ISO) +\(/currentCountry?.CC)"
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized

    }
    func setUpView() {
            
        cnstTableHeight.constant = 0
        
        tfDate.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: nil, minDate: Date(), configureDate: { [weak self] (selectedDate) in
            self?.workingSince = selectedDate
            self?.tfDate.text = selectedDate.toString(DateFormat.custom("MM/dd/yyyy"), timeZone: .local)
        })
        tableViewInit()
//        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
       
        lblCountryCode.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(presentCountryPicker)))
        countryPicker = CountryManager()
        currentCountry = countryPicker?.currentCountry
        
        if comingFrom == .WhileManaging || comingFrom == .WhileInCompleteSetup {
           
            let workingShifts = UserPreference.shared.data?.custom_fields?.first(where: {/$0.field_name == "Working shifts"})?.field_value
            let workExp = UserPreference.shared.data?.custom_fields?.first(where: {/$0.field_name == "Work experience"})?.field_value
            let certification = UserPreference.shared.data?.custom_fields?.first(where: {/$0.field_name == "Certification"})?.field_value
            tfCertification.text = /certification
            
            btnWeekend.isSelected = /workingShifts?.contains("Weekend")
            btnDayShift.isSelected = /workingShifts?.contains("Day shift")
            btnEveningShift.isSelected = /workingShifts?.contains("Evening shift")
            btnLiveIn.isSelected = /workingShifts?.contains("Live in")
            btnNightShift.isSelected = /workingShifts?.contains("Night shift")
            
            btn0Months.isSelected = /workExp?.contains("0-5 months")
            btn6Months.isSelected = /workExp?.contains("6-11 months")
            btn12Months.isSelected = /workExp?.contains("12-24 months")
            btn24Months.isSelected = /workExp?.contains("24+ months")

            selectedShift = btn0Months.isSelected ? btn0Months.titleLabel?.text : btn6Months.isSelected ? btn6Months.titleLabel?.text : btn12Months.isSelected ? btn12Months.titleLabel?.text: btn24Months.isSelected ? btn24Months.titleLabel?.text: ""
            
            tfAddress.text = /UserPreference.shared.data?.profile?.location_name
            tfName.text = UserPreference.shared.data?.name == "1#123@123" ? "" : UserPreference.shared.data?.name
            tfPersonalProfile.text = /UserPreference.shared.data?.profile?.bio
            
            tfLicense.text = /UserPreference.shared.data?.custom_fields?.first(where: {/$0.field_name == "Professional Liscence"})?.field_value
            tfCertification.text = /UserPreference.shared.data?.custom_fields?.first(where: {/$0.field_name == "Certification"})?.field_value
            tfDate.text = /UserPreference.shared.data?.custom_fields?.first(where: {/$0.field_name == "Start Date"})?.field_value
            
            tfEmail.text = /UserPreference.shared.data?.email
            tfMobileNumber.text = /UserPreference.shared.data?.phone
            lblCountryCode.text = UserPreference.shared.data?.country_code ?? "\(/currentCountry?.ISO) +\(/currentCountry?.CC)"
            
        } else {
            tfMobileNumber.text = /UserPreference.shared.data?.phone
            lblCountryCode.text = UserPreference.shared.data?.country_code ?? "\(/currentCountry?.ISO) +\(/currentCountry?.CC)"

            tfEmail.text = /UserPreference.shared.data?.email
            
            vwEmail.isHidden = /UserPreference.shared.data?.email != ""
            vwMobile.isHidden = /UserPreference.shared.data?.phone != ""
            
        }
        
        if UserPreference.shared.data?.provider_type == ProviderType.email {
            vwEmail.isHidden = true
        } else {
            vwMobile.isHidden = true
        }
    }
    
    private func addPlacePicker() {
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        resultsViewController?.primaryTextColor = ColorAsset.txtDark.color

        // Sets the background of results - second line
        resultsViewController?.secondaryTextColor = ColorAsset.txtDark.color

        if #available(iOS 13.0, *) {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                resultsViewController?.primaryTextColor = UIColor.white
                resultsViewController?.secondaryTextColor = UIColor.lightGray
                resultsViewController?.tableCellSeparatorColor = UIColor.lightGray
                resultsViewController?.tableCellBackgroundColor = UIColor.darkGray
            } else {
                resultsViewController?.primaryTextColor = UIColor.black
                resultsViewController?.secondaryTextColor = UIColor.lightGray
                resultsViewController?.tableCellSeparatorColor = UIColor.lightGray
                resultsViewController?.tableCellBackgroundColor = UIColor.white
            }
        }

        present(searchController ?? UISearchController(), animated: true, completion: nil)
    }
    
    @objc private func presentCountryPicker() {
        countryPicker?.openCountryPicker({ [weak self] (country) in
            self?.currentCountry = country
            self?.lblCountryCode.text = "\(/self?.currentCountry?.ISO) +\(/self?.currentCountry?.CC)"
        })
    }
    
    @objc private func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
            }, nil, nil)
    }
    
    
    private func uploadImageAPI() {
        playUploadAnimation(on: imgView)
        EP_Home.uploadImage(image: (imgView.image)!, type: MediaTypeUpload.image, doc: nil).request(success: { [weak self] (responseData) in
            self?.stopUploadAnimation()
            self?.image_URL = (responseData as? ImageUploadData)?.image_name
        }) { [weak self] (error) in
            self?.stopUploadAnimation()
            self?.alertBox(title: VCLiteral.UPLOAD_ERROR.localized, message: error, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.RETRY.localized, tapped1: {
                self?.imgView.image = nil
            }, tapped2: {
                self?.uploadImageAPI()
            })
        }
    }
    
    private func uploadData () {
        var customFields: String?
        var fields = [CustomField]()
        
        if let work = UserPreference.shared.clientDetail?.getCustomField(for: .WorkingShifts, user: .service_provider) {
            
            var shifts = [String]()
            
            if btnNightShift.isSelected {
                shifts.append(/btnNightShift.titleLabel?.text)
            }
            if btnDayShift.isSelected {
                shifts.append(/btnDayShift.titleLabel?.text)
            }
            if btnEveningShift.isSelected {
                shifts.append(/btnEveningShift.titleLabel?.text)
            }
            if btnLiveIn.isSelected {
                shifts.append(/btnLiveIn.titleLabel?.text)
            }
            if btnWeekend.isSelected {
                shifts.append(/btnWeekend.titleLabel?.text)
            }
            work.field_value = /shifts.joined(separator: ", ")
            fields.append(work)
        }
        if let exp = UserPreference.shared.clientDetail?.getCustomField(for: .WorkExperience, user: .service_provider) {
            exp.field_value = /selectedShift
            fields.append(exp)
        }
       
        if let professional = UserPreference.shared.clientDetail?.getCustomField(for: .ProfessionalLiscence, user: .service_provider) {
            
            professional.field_value = /tfLicense.text
            fields.append(professional)
        }
        if let professional = UserPreference.shared.clientDetail?.getCustomField(for: .Certification, user: .service_provider) {
            
            professional.field_value = /tfCertification.text
            fields.append(professional)
        }
        if workingSince != nil {
            if let startDate = UserPreference.shared.clientDetail?.getCustomField(for: .StartDate, user: .service_provider) {
                
                startDate.field_value = workingSince?.toString(DateFormat.custom("yyyy-MM-dd"))
                fields.append(startDate)
            }
        } else {
            if let startDate = UserPreference.shared.clientDetail?.getCustomField(for: .StartDate, user: .service_provider) {
                
                startDate.field_value = /tfDate.text//workingSince?.toString(DateFormat.custom("yyyy-MM-dd"))
                fields.append(startDate)
            }
        }
        if fields.count > 0 {
            customFields = JSONHelper<[CustomField]>().toJSONString(model: fields)
        }
        
        switch Validation.shared.validate(values: (.PHONE, /tfMobileNumber.text)) {
        case .success:
            updateProfile(customFields: customFields)
        case .failure(let alertType, let message):
            Toast.shared.showAlert(type: alertType, message: message.localized)
        }
        
    }
    
    private func updateProfile(customFields: String?) {
        btnContinue.playAnimation()
        EP_Login.profileUpdate(name: tfName.text, email: /tfEmail.text, phone: /tfMobileNumber.text, country_code: "+\(/currentCountry?.CC)", dob: nil, bio: /tfPersonalProfile.text, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: image_URL, workingSince: nil, namePrefix: nil, custom_fields: customFields, master_preferences: nil, address: tfAddress.text, lat: currentLat, long: currentLong).request(success: { [weak self] (response) in
            
            self?.view.isUserInteractionEnabled = true
            self?.btnContinue.stop()
            
            self?.updateServices()
            
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.btnContinue.stop()
        }
    }
    
    private func updateServices() {
        
        var filterToSend = [FilterToSend]()
        
        let ids = (categories.filter({/$0.isSelected})).compactMap({/$0.id})
        filterToSend.append(FilterToSend.init(1, ids))
        
        let jsonFilters = JSONHelper<[FilterToSend]>().toDictionary(model: filterToSend)
        
        var idarr = [String]()
        for id in ids {
            idarr.append("\(/id)")
        }
        let services = JSONHelper<[ServiceTypeToSend]>().toDictionary(model: [ServiceTypeToSend.init(1, .TRUE, 10, 5, nil, false)])
       
        btnContinue.playAnimation()
        EP_Home.updateServices(categoryId: "1", filters: jsonFilters, category_services_type: services).request(success: { [weak self] (responseData) in
            self?.btnContinue.stop()
            
            switch self?.comingFrom ?? .WhileLoginModule {
            case .WhileManaging:
                self?.popVC()
            default:
                
                let destVC = Storyboard<PersonalInterestVC>.LoginSignUp.instantiateVC()
                destVC.filterIds = idarr.joined(separator: ", ")
                
                self?.pushVC(destVC)
                
            }
        }) { (_) in
        }
    }
}
extension SetupProfileVC {
    
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<FilterOption>, DefaultCellModel<FilterOption>, FilterOption>.init(.SingleListing(items: categories, identifier: RegisterCategoryCell.identfier, height: 48.0, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? RegisterCategoryCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            
            self?.categories.forEach({ $0.isSelected = false })

            self?.categories[indexPath.row].isSelected = !(/self?.categories[indexPath.row].isSelected)
            self?.tableView.reloadData()
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getCategoriesAPI()
        }
        dataSource?.refreshProgrammatically()
    }
    
    private func getCategoriesAPI() {
        
        EP_Login.getFilters(categoryId: "1").request(success: { [weak self] (responseData) in
        
            self?.categories = (responseData as? FilterData)?.filters?.first?.options ?? []
          
            let a = UserPreference.shared.data?.filters?.first?.options ?? []
            self?.categories.forEach({ (category) in
                category.isSelected = a.contains(where: {/$0.id == /category.id && ($0.isSelected != nil)})
            })
            
            self?.cnstTableHeight.constant = CGFloat(/self?.categories.count * 48)
            
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.categories ?? []), .FullReload)
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
        }) { [weak self] (error) in
          
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
            if /self?.categories.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
}

extension SetupProfileVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        tfAddress.text = /place.name
        searchController?.searchBar.text = place.formattedAddress
        currentLat = "\(/place.coordinate.latitude)"
        currentLong = "\(/place.coordinate.longitude)"
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension SetupProfileVC: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfDate {
            self.workingSince = Date()
            self.tfDate.text = Date().toString(DateFormat.custom("MM/dd/yyyy"), timeZone: .local)
        }
    }
}

