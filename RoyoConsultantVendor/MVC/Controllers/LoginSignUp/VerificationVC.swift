//
//  VerificationVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VerificationVC: BaseVC {
    
    @IBOutlet weak var lblVerification: UILabel!
    @IBOutlet weak var lblCodeSentTo: UILabel!
    @IBOutlet weak var tfDigit1: OTPTextField!
    @IBOutlet weak var tfDigit2: OTPTextField!
    @IBOutlet weak var tfDigit3: OTPTextField!
    @IBOutlet weak var tfDigit4: OTPTextField!
    @IBOutlet weak var lblNotReceiveCode: UILabel!
    @IBOutlet weak var btnResend: SKLottieButton!
    
    var phone: (cc: String, number: String)?
    var providerType: ProviderType = .phone
    var email: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        
        nextBtnAccessory.didTapContinue = { [weak self] in
            let btn = UIButton.init()
            btn.tag = 2
            self?.btnAction(btn)
        }
        
        [tfDigit1, tfDigit2, tfDigit3, tfDigit4].forEach({ [weak self] in
            $0?.delegate = self
            $0?.didTapBackward = {
                self?.backwardTapped()
            }
        })
        
        tfDigit1.becomeFirstResponder()
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
        case 1: //Resend Code
            resendOTP()
        case 2: //Next
            
            verifyOTP()
            
        default:
            break
        }
    }
    
    private func resendOTP() {
        if providerType == .email {
            btnResend.playAnimation()
            EP_Login.sendEmailOTP(email: /email).request(success: { [weak self] (responseData) in
                self?.btnResend.stop()
                
            }) { [weak self] (error) in
                self?.btnResend.stop()
            }
        } else {
            btnResend.setAnimationType(.BtnAppTintLoader)
            btnResend.playAnimation()
            EP_Login.sendOTP(phone: /phone?.number, countryCode: "+\(/phone?.cc)").request(success: { [weak self] (responseData) in
                self?.btnResend.stop()
            }) { [weak self] (error) in
                self?.btnResend.stop()
            }
        }
    }
    
}

//MARK:- VCFuncs
extension VerificationVC {
    private func localizedTextSetup() {
        lblVerification.text = VCLiteral.VERIFICATION.localized
        
        if providerType == .email {
            lblCodeSentTo.text = String.init(format: VCLiteral.CODESENT.localized, /email)

        } else {
            lblCodeSentTo.text = String.init(format: VCLiteral.CODESENT.localized, "+\(/phone?.cc)-\(/phone?.number)")
        }
        lblNotReceiveCode.text = VCLiteral.CODE_NOT_RECEIVED.localized
        btnResend.setTitle(VCLiteral.RESEND_CODE.localized, for: .normal)
    }
    
    private func verifyOTP() {
        let otp = /tfDigit1.text?.trimmingCharacters(in: .whitespaces) + /tfDigit2.text?.trimmingCharacters(in: .whitespaces) + /tfDigit3.text?.trimmingCharacters(in: .whitespaces) + /tfDigit4.text?.trimmingCharacters(in: .whitespaces)
        if otp.count == 4 {
            switch providerType {
            case .phone:
                loginAPI(otp)
            case .facebook, .google:
                 
                updateProfileAPI()
            case .email:
                view.isUserInteractionEnabled = false
                nextBtnAccessory.startAnimation()
                EP_Login.verifyEmailOTP(email: /self.email, otp: otp).request(success: { [weak self] (response) in
                    
                    EP_Login.register(name: "1#123@123", email: self?.email, password: self?.password, phone: nil, code: nil, user_type: .service_provider, fcm_id: UserPreference.shared.firebaseToken, country_code: nil, dob: nil, bio: nil, profile_image: nil, workingSince: nil, provider_type: ProviderType.email).request(success: { [weak self] (response) in
                        self?.view.isUserInteractionEnabled = true

                        self?.nextBtnAccessory.stopAnimation()
                        let destVC = Storyboard<SetupProfileVC>.LoginSignUp.instantiateVC()
                        self?.pushVC(destVC)

                    }) { [weak self] (_) in
                        self?.nextBtnAccessory.stopAnimation()
                    }
                    
                }) { [weak self] (error) in
                    self?.view.isUserInteractionEnabled = true
                    self?.nextBtnAccessory.stopAnimation()
                }
            case .apple:
                view.isUserInteractionEnabled = false
                nextBtnAccessory.startAnimation()
                EP_Login.updatePhone(phone: /phone?.number, countryCode: "+\(/phone?.cc)", otp: otp).request(success: { [weak self] (response) in
                    self?.view.isUserInteractionEnabled = true
                    self?.nextBtnAccessory.stopAnimation()
                    let destVC = Storyboard<SignUpInterMediateVC>.LoginSignUp.instantiateVC()
                    destVC.isViaAppleSignUp = true
                    self?.pushVC(destVC)
                }) { [weak self] (error) in
                    self?.view.isUserInteractionEnabled = true
                    self?.nextBtnAccessory.stopAnimation()
                }
            case .unknown:
                break
            }
        }
    }
    
    private func loginAPI(_ otp: String) {
        view.isUserInteractionEnabled = false
        nextBtnAccessory.startAnimation()
        EP_Login.login(provider_type: .phone, provider_id: phone?.number, provider_verification: otp, user_type: .service_provider, country_code: "+\(/phone?.cc)").request(success: { [weak self] (responseData) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
            
//            if /(responseData as? User)?.name == "" {
            if /UserPreference.shared.data?.token == "" || /UserPreference.shared.data?.master_preferences?.count == 0 || /UserPreference.shared.data?.additionals?.count == 0 {

                let destVC = Storyboard<SetupProfileVC>.LoginSignUp.instantiateVC()
                destVC.comingFrom = .WhileInCompleteSetup
                self?.pushVC(destVC)
            } else { //Redirect to Home screen
                
                UIWindow.replaceRootVC(Storyboard<NavigationTabVC>.TabBar.instantiateVC())
            }
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
        }
    }
    
    private func updateProfileAPI() {
        view.isUserInteractionEnabled = false
        nextBtnAccessory.startAnimation()
        EP_Login.profileUpdate(name: /UserPreference.shared.data?.name, email: UserPreference.shared.data?.email, phone: /phone?.number, country_code: "+\(/phone?.cc)", dob: UserPreference.shared.data?.profile?.dob, bio: nil, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: nil, workingSince: nil, namePrefix: nil, custom_fields: nil, master_preferences: nil, address: nil, lat: nil,long: nil).request(success: { [weak self] (response) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
            if /UserPreference.shared.data?.services?.count == 0 {
                let destVC = Storyboard<CategoriesVC>.LoginSignUp.instantiateVC()
                self?.pushVC(destVC)
            } else {
                UIWindow.replaceRootVC(Storyboard<NavigationTabVC>.TabBar.instantiateVC())
            }
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
        }
    }
}

//MARK:- UITextFieldDelegate
extension VerificationVC: UITextFieldDelegate {
    func backwardTapped() {
        if tfDigit2.isFirstResponder{
            tfDigit1.becomeFirstResponder()
        }
        if tfDigit3.isFirstResponder{
            tfDigit2.becomeFirstResponder()
        }
        if tfDigit4.isFirstResponder{
            tfDigit3.becomeFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var shouldProcess = false //default to reject
        var shouldMoveToNextField = false //default to remaining on the current field
        let  insertStrLength = string.count
        
        if insertStrLength == 0 {
            
            shouldProcess = true //Process if the backspace character was pressed
            
        } else {
            if /textField.text?.count <= 1 {
                shouldProcess = true //Process if there is only 1 character right now
            }
        }
        
        if shouldProcess {
            
            var mString = ""
            if mString.count == 0 {
                
                mString = string
                shouldMoveToNextField = true
                
            } else {
                //adding a char or deleting?
                if(insertStrLength > 0){
                    mString = string
                    
                } else {
                    //delete case - the length of replacement string is zero for a delete
                    mString = ""
                }
            }
            
            //set the text now
            textField.text = mString
            
            if (shouldMoveToNextField&&textField.text?.count == 1) {
                
                if (textField == tfDigit1) {
                    tfDigit2.becomeFirstResponder()
                    
                } else if (textField == tfDigit2){
                    tfDigit3.becomeFirstResponder()
                    
                } else if (textField == tfDigit3){
                    tfDigit4.becomeFirstResponder()
                    
                } else {
                    tfDigit4.resignFirstResponder()
                    verifyOTP()
                }
            }
            else{
                backwardTapped()
            }
        }
        return false
    }
}
