//
//  SignUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import SZTextView
import IQKeyboardManagerSwift
import JVFloatLabeledTextField

class SignUpVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    //    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNamePrefix: UILabel!
    
    //    @IBOutlet weak var tfFirstName: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var tfPsw: JVFloatLabeledTextField!
    //    @IBOutlet weak var tfDOB: JVFloatLabeledTextField!
    //    @IBOutlet weak var tfWorkingSince: JVFloatLabeledTextField!
    //    @IBOutlet weak var tvBio: SZTextView!
    @IBOutlet weak var btnNext: SKLottieButton!
    @IBOutlet weak var btnTermsAccept: UIButton!
    @IBOutlet weak var btnTerms: UIButton!

    private var dob: Date?
    private var workingSince: Date?
    private var image_URL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizedTextSetup()
        
        //        tfDOB.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: Date().dateBySubtractingMonths(5 * 12), minDate: nil, configureDate: { [weak self] (selectedDate) in
        //            self?.dob = selectedDate
        //            self?.tfDOB.text = selectedDate.toString(DateFormat.custom("MM/dd/yyyy"), timeZone: .local)
        //        })
        //
        //        tfWorkingSince.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: Date(), minDate: nil, configureDate: { [weak self] (selectedDate) in
        //            self?.workingSince = selectedDate
        //            self?.tfWorkingSince.text = selectedDate.toString(DateFormat.custom("MM/dd/yyyy"), timeZone: .local)
        //        })
        
        lblNamePrefix.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(namePrefixTapped)))
        //        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Next
            switch Validation.shared.validate(values: (.EMAIL, /tfEmail.text), (.PASSWORD, /tfPsw.text)) {
            case .success:
                if !btnTermsAccept.isSelected {
                    Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.REGSITER_CAT_TERMS_ALERT.localized)
                } else {
                    registerAPI()
                }
            case .failure(let alertType, let message):
                Toast.shared.showAlert(type: alertType, message: message.localized)
            }
        case 2: //Terms of service
            let destVC = Storyboard<WebLinkVC>.Other.instantiateVC()
            destVC.linkTitle = (APIConstants.basepath + APIConstants.termsConditions, VCLiteral.TERMS_AND_CONDITIONS.localized)
            pushVC(destVC)

        case 5:
            btnTermsAccept.isSelected = !btnTermsAccept.isSelected

        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension SignUpVC {
    
    private func registerAPI() {
        btnNext.playAnimation()
        
        EP_Login.sendEmailOTP(email: tfEmail.text).request(success: { [weak self] (responseData) in
            self?.btnNext.stop()
            let destVC = Storyboard<VerificationVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .email
            destVC.email = /self?.tfEmail.text
            destVC.password = /self?.tfPsw.text
            self?.pushVC(destVC)
            
        }) { [weak self] (error) in
            self?.btnNext.stop()
        }
        return
        
//        EP_Login.register(name: "1#123@123", email: tfEmail.text, password: tfPsw.text, phone: nil, code: nil, user_type: .service_provider, fcm_id: UserPreference.shared.firebaseToken, country_code: nil, dob: nil, bio: nil, profile_image: nil, workingSince: nil).request(success: { [weak self] (response) in
//            self?.btnNext.stop()
//            let destVC = Storyboard<SetupProfileVC>.LoginSignUp.instantiateVC()
//            self?.pushVC(destVC)
//
////            let destVC = Storyboard<SetupProfileVC>.LoginSignUp.instantiateVC()
////            self?.pushVC(destVC)
//
////            if /UserPreference.shared.data?.services?.count == 0 {
////                let destVC = Storyboard<CategoriesVC>.LoginSignUp.instantiateVC()
////                self?.pushVC(destVC)
////            } else {
////                UIWindow.replaceRootVC(Storyboard<NavigationTabVC>.TabBar.instantiateVC())
////            }
//        }) { [weak self] (_) in
//            self?.btnNext.stop()
//        }
    }
    
    //    private func uploadImageAPI() {
    //        playUploadAnimation(on: imgView)
    //        EP_Home.uploadImage(image: (imgView.image)!).request(success: { [weak self] (responseData) in
    //            self?.stopUploadAnimation()
    //            self?.image_URL = (responseData as? ImageUploadData)?.image_name
    //        }) { [weak self] (error) in
    //            self?.stopUploadAnimation()
    //            self?.alertBox(title: VCLiteral.UPLOAD_ERROR.localized, message: error, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.RETRY_SMALL.localized, tapped1: {
    //                self?.imgView.image = nil
    //            }, tapped2: {
    //                self?.uploadImageAPI()
    //            })
    //        }
    //    }
    
    //    @objc func selectImage() {
    //        view.endEditing(true)
    //        mediaPicker.presentPicker({ [weak self] (image) in
    //            self?.imgView.image = image
    //            self?.uploadImageAPI()
    //        }, nil, nil)
    //    }
    
    //Interaction ID: Nitin - 1083491851
    //Interaction ID: 1083609231
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
    //122558134
    
    private func localizedTextSetup() {
        btnTermsAccept.titleLabel?.numberOfLines = 2
        btnTermsAccept.setTitle(VCLiteral.TERMS_AGREED.localized, for: .normal)
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)

        tfPsw.placeholder = VCLiteral.PSW_PLACEHOLDER.localized
        //        tfFirstName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
        //        tfDOB.placeholder = VCLiteral.DOB_PLACEHOLDER.localized
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        // tvBio.placeholder = VCLiteral.BIO_PLACEHOLDER.localized
        btnNext.setTitle(VCLiteral.NEXT.localized, for: .normal)
        lblTitle.text = VCLiteral.SIGNUP_CONNECT_CARE.localized
    }
}
