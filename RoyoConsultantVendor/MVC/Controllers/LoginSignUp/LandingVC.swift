//
//  LandingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class LandingVC: BaseVC {
    
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var appleBtn: AppleSignInButton!
    @IBOutlet weak var lblAccountToContinue: UILabel!
    @IBOutlet weak var lblByContinue: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
//    @IBOutlet weak var btnPrivacy: UIButton!
//    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var lblAlreadyAccount: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewForLottie: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizedTextSetup()
        //        appleBtn.didCompletedSignIn = { (data) in
        //            self.loginAPI(providerType: .apple, loginData: data)
        //        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Facebook
            FBLogin.shared.login { [weak self] (loginData) in
                self?.loginAPI(providerType: .facebook, loginData: loginData)
            }
        case 2: //Signup using Email
            let destVC = Storyboard<
                SignUpVC>.LoginSignUp.instantiateVC()
            pushVC(destVC)
        case 3: //Signup using Mobile Number
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .email
            pushVC(destVC)
        case 4: //Login
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .phone
            pushVC(destVC)
        case 5: //Terms
            let destVC = Storyboard<WebLinkVC>.Other.instantiateVC()
            destVC.linkTitle = (APIConstants.basepath + APIConstants.termsConditions, VCLiteral.TERMS.localized)
            pushVC(destVC)
        case 6: //Privacy Policy
            let destVC = Storyboard<WebLinkVC>.Other.instantiateVC()
            destVC.linkTitle = (APIConstants.basepath + APIConstants.privacyPolicy, VCLiteral.PRIVACY.localized)
            pushVC(destVC)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension LandingVC {
    private func loginAPI(providerType: ProviderType, loginData: GoogleAppleFBUserData?) {
        startAnimation()
        EP_Login.login(provider_type: providerType, provider_id: nil, provider_verification: /loginData?.accessToken, user_type: .service_provider, country_code: nil).request(success: { [weak self] (response) in
            
            self?.stopAnimation()
            if /(response as? User)?.services?.count == 0 {
                let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
                destVC.providerType = providerType
                self?.pushVC(destVC)
            } else {
                UIWindow.replaceRootVC(Storyboard<NavigationTabVC>.TabBar.instantiateVC())
            }
        }) { [weak self] (error) in
            self?.stopAnimation()
        }
    }
    
    private func localizedTextSetup() {
        
        lblFacebook.text = VCLiteral.FACEBOOK.localized
        lblEmail.text = VCLiteral.SIGNUP_USING_EMAIL.localized
        lblMobileNumber.text = VCLiteral.SIGNUP_USING_PHONE.localized
        lblByContinue.text = VCLiteral.BY_CONTNUE.localized
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)
//        btnPrivacy.setTitle(VCLiteral.PRIVACY.localized, for: .normal)
//        lblAnd.text = VCLiteral.AND.localized
        lblAccountToContinue.text = VCLiteral.ACCOUNT_TO_CONTINUE.localized
        lblAlreadyAccount.text = VCLiteral.ALREADY_ACCOUNT.localized
        btnLogin.setTitle(VCLiteral.LOGIN.localized, for: .normal)
    }
    
    
    private func startAnimation() {
        view.isUserInteractionEnabled = false
        lineAnimation.removeFromSuperview()
        let width = UIScreen.main.bounds.width
        let height = width * (5 / 450)
        lineAnimation.frame = CGRect.init(x: 0, y: 0, width: width, height: height - 2.0)
        viewForLottie.addSubview(lineAnimation)
        lineAnimation.clipsToBounds = true
        lineAnimation.play()
    }
    
    private func stopAnimation() {
        lineAnimation.stop()
        lineAnimation.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
}
