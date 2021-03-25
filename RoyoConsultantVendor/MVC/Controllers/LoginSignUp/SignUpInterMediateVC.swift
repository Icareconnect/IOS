//
//  SignUpInterMediateVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import SZTextView
import JVFloatLabeledTextField

class SignUpInterMediateVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNamePrefix: UILabel!
    
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var tfDOB: JVFloatLabeledTextField!
    @IBOutlet weak var tfWorkingSince: JVFloatLabeledTextField!
    @IBOutlet weak var tvBio: SZTextView!
    
    private var dob: Date?
    private var workingSince: Date?
    private var image_URL: String?
    public var comingFrom: AvailabilityDataType = .WhileLoginModule
    public var isViaAppleSignUp: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        nextBtnAccessory.didTapContinue = { [weak self] in
            let btn = UIButton()
            btn.tag = 1
            self?.btnAction(btn)
        }
        
        tfResponder = TFResponder()
        tfResponder?.addResponders([.TF(tfName), .TF(tfEmail), .TF(tfDOB), .TF(tfWorkingSince), .TV(tvBio)])
        
        tfDOB.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: Date().dateBySubtractingMonths(5 * 12), minDate: nil, configureDate: { [weak self] (selectedDate) in
            self?.dob = selectedDate
            self?.tfDOB.text = selectedDate.toString(DateFormat.custom("MM/dd/yyyy"), timeZone: .local)
        })
        
        tfWorkingSince.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: Date(), minDate: nil, configureDate: { [weak self] (selectedDate) in
            self?.workingSince = selectedDate
            self?.tfWorkingSince.text = selectedDate.toString(DateFormat.custom("MM/dd/yyyy"), timeZone: .local)
        })
        
        lblNamePrefix.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(namePrefixTapped)))
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return nextBtnAccessory
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Next
            switch Validation.shared.validate(values: (ValidationType.NAME, /tfName.text), (ValidationType.EMAIL, /tfEmail.text), (ValidationType.DOB, /tfDOB.text), (ValidationType.WORKING_SINCE, /tfWorkingSince.text)) {
            case .success:
                updateProfileAPI()
            case .failure(let alertType, let message):
                Toast.shared.showAlert(type: alertType, message: message.localized)
            }
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension SignUpInterMediateVC {
    
    private func updateProfileAPI() {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        nextBtnAccessory.startAnimation()
        
        EP_Login.profileUpdate(name: tfName.text, email: tfEmail.text, phone: nil, country_code: nil, dob: dob?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local), bio: tvBio.text, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: image_URL, workingSince: workingSince?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local), namePrefix: /lblNamePrefix.text, custom_fields: nil, master_preferences: nil, address: nil, lat: nil,long: nil).request(success: { [weak self] (response) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
            
            switch self?.comingFrom ?? .WhileLoginModule {
            case .WhileLoginModule:
                if /UserPreference.shared.data?.services?.count == 0 {
                    let destVC = Storyboard<CategoriesVC>.LoginSignUp.instantiateVC()
                    self?.pushVC(destVC)
                } else {
                    UIWindow.replaceRootVC(Storyboard<NavigationTabVC>.TabBar.instantiateVC())
                }
            case .WhileManaging:
                self?.popTo(toControllerType: ProfileDetailVC.self)
                
            default:
                break
            }
            
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
        }
    }
    
    private func uploadImageAPI() {
        playUploadAnimation(on: imgView)
        EP_Home.uploadImage(image: (imgView.image)!, type: MediaTypeUpload.image, doc: nil).request(success: { [weak self] (responseData) in
            self?.stopUploadAnimation()
            self?.image_URL = (responseData as? ImageUploadData)?.image_name
        }) { [weak self] (error) in
            self?.stopUploadAnimation()
            self?.alertBox(title: VCLiteral.UPLOAD_ERROR.localized, message: error, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.RETRY_SMALL.localized, tapped1: {
                self?.imgView.image = nil
            }, tapped2: {
                self?.uploadImageAPI()
            })
        }
    }
    
    @objc func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
            }, nil, nil)
    }
    
    @objc private func namePrefixTapped() {
        view.endEditing(true)
        let prefixes = [VCLiteral.NAME_PREFIX_MR.localized,
                        VCLiteral.NAME_PREFIX_MRS.localized,
                        VCLiteral.NAME_PREFIX_MISS.localized,
                        VCLiteral.NAME_PREFIX_DR.localized]
        actionSheet(for: prefixes, title: nil, message: nil, view: lblNamePrefix) { [weak self] (selectedPrefix) in
            self?.lblNamePrefix.text = /selectedPrefix
        }
    }
    
    private func localizedTextSetup() {
        
        tfName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
        tfDOB.placeholder = VCLiteral.DOB_PLACEHOLDER.localized
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        tvBio.placeholder = VCLiteral.BIO_PLACEHOLDER.localized
        
        switch comingFrom {
        case .WhileManaging: //Editing Profile Data
            lblTitle.text = VCLiteral.EDIT_PROFILE.localized
            
            let user = UserPreference.shared.data
            
            lblNamePrefix.text = user?.profile?.title ?? VCLiteral.NAME_PREFIX_DR.localized
            tfName.text = /user?.name
            tfEmail.text = /user?.email
            tfDOB.text = Date.init(fromString: /user?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom("MM/dd/yyyy"), timeZone: .local)
            tfWorkingSince.text = Date.init(fromString: /user?.profile?.working_since, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom("MM/dd/yyyy"), timeZone: .local)
            tvBio.text = /user?.profile?.bio
            imgView.setImageNuke(/user?.profile_image, placeHolder: nil)
        case .WhileLoginModule:
            lblTitle.text = String.init(format: VCLiteral.JOINCONSULTANTS.localized, "2500")
            
        default:
            break
        }
        
        switch UserPreference.shared.data?.provider_type ?? .phone {
        case .facebook, .google, .apple:
            tfEmail.isUserInteractionEnabled = false
        default:
            tfEmail.isUserInteractionEnabled = true
        }
        
        if /isViaAppleSignUp {
            tfName.text = /UserPreference.shared.appleData?.name
            tfEmail.text = /UserPreference.shared.appleData?.email
            tfEmail.isUserInteractionEnabled = /UserPreference.shared.appleData?.email == ""
        }
    }
}
