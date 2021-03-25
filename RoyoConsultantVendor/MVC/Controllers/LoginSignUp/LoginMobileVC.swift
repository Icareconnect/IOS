//
//  LoginMobileVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class LoginMobileVC: BaseVC {
    
    @IBOutlet weak var lblEnterMobNo: UILabel!
    @IBOutlet weak var lblEnterMobNoDesc: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var lblByContinue: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var lblLoginWith: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnTermsAccept: UIButton!

    @IBOutlet weak var vwTerms: UIView!
    
    private var countryPicker: CountryManager?
    private var currentCountry: CountryISO?
    public var providerType: ProviderType = .phone

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCountryCode.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(presentCountryPicker)))
        countryPicker = CountryManager()
        currentCountry = countryPicker?.currentCountry
        localizedTextSetup()
        
        nextBtnAccessory.didTapContinue = { [weak self] in
            let btn = UIButton.init()
            btn.tag = 1
            self?.btnAction(btn)
        }
        
        tfResponder = TFResponder()
        tfResponder?.addResponders([TVTF.TF(tfMobileNumber)])
        tfMobileNumber.becomeFirstResponder()
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
            popTo(toControllerType: LandingVC.self)
        case 1: //Next
            switch Validation.shared.validate(values: (.PHONE, /tfMobileNumber.text)) {
            case .success:
                if !btnTermsAccept.isSelected && !vwTerms.isHidden {
                    Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.REGSITER_CAT_TERMS_ALERT.localized)
                } else {
                    loginAPI()
                }
            case .failure(let alertType, let message):
                Toast.shared.showAlert(type: alertType, message: message.localized)
            }
        case 2: //Terms of service
            let destVC = Storyboard<WebLinkVC>.Other.instantiateVC()
            destVC.linkTitle = (APIConstants.basepath + APIConstants.termsConditions, VCLiteral.TERMS_AND_CONDITIONS.localized)
            pushVC(destVC)
        case 3: //Privacy Policy
            let destVC = Storyboard<WebLinkVC>.Other.instantiateVC()
            destVC.linkTitle = (APIConstants.basepath + APIConstants.privacyPolicy, VCLiteral.PRIVACY.localized)
            pushVC(destVC)
        case 4: //Login Email
            if providerType == .phone {
                let destVC = Storyboard<LoginEmailVC>.LoginSignUp.instantiateVC()
                pushVC(destVC)
            } else {
                let destVC = Storyboard<SignUpVC>.LoginSignUp.instantiateVC()
                pushVC(destVC)
            }
        case 5:
            btnTermsAccept.isSelected = !btnTermsAccept.isSelected
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension LoginMobileVC {
    
    private func loginAPI() {
        view.isUserInteractionEnabled = false
        nextBtnAccessory.startAnimation()
        
        EP_Login.sendOTP(phone: /tfMobileNumber.text, countryCode: "+\(/currentCountry?.CC)").request(success: { [weak self] (responseData) in
            self?.nextBtnAccessory.stopAnimation()
            self?.view.isUserInteractionEnabled = true
            let destVC = Storyboard<VerificationVC>.LoginSignUp.instantiateVC()
            destVC.phone = (/self?.currentCountry?.CC, /self?.tfMobileNumber.text)
            destVC.providerType = /*self?.providerType ?? */.phone
            self?.pushVC(destVC)
        }) { [weak self] (error) in
            self?.nextBtnAccessory.stopAnimation()
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    
    @objc private func presentCountryPicker() {
        countryPicker?.openCountryPicker({ [weak self] (country) in
            self?.currentCountry = country
            self?.lblCountryCode.text = "\(/self?.currentCountry?.ISO) +\(/self?.currentCountry?.CC)"
        })
    }
    
    private func localizedTextSetup() {
        
        btnTermsAccept.titleLabel?.numberOfLines = 2
        btnTermsAccept.setTitle(VCLiteral.TERMS_AGREED.localized, for: .normal)

        lblEnterMobNo.text = VCLiteral.LOGIN_USING_MOBILE.localized
        lblEnterMobNoDesc.text = ""//VCLiteral.LOGIN_USING_MOBILE_DESC.localized
        tfMobileNumber.placeholder = VCLiteral.MOBILE_PACEHOLDER.localized
        lblCountryCode.text = "\(/currentCountry?.ISO) +\(/currentCountry?.CC)"
        lblByContinue.text = VCLiteral.BY_CONTNUE.localized
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)

        if providerType == .phone {
            lblLoginWith.text = VCLiteral.LOGIN_WITH.localized
            lblEnterMobNo.text = VCLiteral.LOGIN_USING_MOBILE.localized
            vwTerms.isHidden = true
        } else {
            lblLoginWith.text = VCLiteral.SIGNUP_WITH.localized
            lblEnterMobNo.text = VCLiteral.SIGNUP_CONNECT_CARE.localized
            vwTerms.isHidden = false

        }
        btnEmail.setTitle(VCLiteral.EMAIL_PLACEHOLDER.localized, for: .normal)
    }
}
