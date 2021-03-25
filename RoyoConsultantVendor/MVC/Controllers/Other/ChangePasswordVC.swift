//
//  ChangePasswordVC.swift
//  RoyoConsultantVendor
//
//  Created by Chitresh Goyal on 05/10/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ChangePasswordVC: BaseVC {
    
    @IBOutlet weak var tfPassword: JVFloatLabeledTextField!
    @IBOutlet weak var tfConfirmPassword: JVFloatLabeledTextField!
    @IBOutlet weak var tfOldPassword: JVFloatLabeledTextField!

    @IBOutlet weak var btnSubmit: SKLottieButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
    }
    @IBAction func actionBack(_ sender: Any) {
        popVC()
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        switch Validation.shared.validate(values: (.PASSWORD, /tfOldPassword.text),(.PASSWORD, /tfPassword.text), (.ReEnterPassword, /tfConfirmPassword.text)) {
        case .success:
            if /tfPassword.text == /tfConfirmPassword.text {
                updatePassword()
            } else {
                Toast.shared.showAlert(type: .validationFailure, message: AlertMessage.PASSWORD_NOT_MATCHED.localized)
            }
        case .failure(let alertType, let meessage):
            Toast.shared.showAlert(type: alertType, message: meessage.localized)
        }
    }
    
    @IBAction func actionShowPassword(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
            sender.tintColor = !tfPassword.isSecureTextEntry ? ColorAsset.txtTheme.color: ColorAsset.txtExtraLight.color

        default:
            tfConfirmPassword.isSecureTextEntry = !tfConfirmPassword.isSecureTextEntry
            sender.tintColor = !tfConfirmPassword.isSecureTextEntry ? ColorAsset.txtTheme.color: ColorAsset.txtExtraLight.color
        }
    }
}
extension ChangePasswordVC {
    private func localizedTextSetup() {
        
        btnSubmit.setTitle(VCLiteral.UPDATE.localized, for: .normal)

        tfPassword.placeholder = VCLiteral.NEW_PASSWORD.localized
        tfOldPassword.placeholder = VCLiteral.OLD_PASSWORD.localized
        tfConfirmPassword.placeholder = VCLiteral.CONFIRM_PASSWORD.localized
        
        lblTitle.text = VCLiteral.CHANEG_PASSWORD.localized

    }
    
    private func updatePassword() {
        btnSubmit.playAnimation()
        
        EP_Login.updatePassword(current_password: /tfOldPassword.text, new_password: tfPassword.text).request(success: { [weak self] (response) in
            
            Toast.shared.showAlert(type: .success, message: VCLiteral.PasswordUpdateSuccess.localized)
            self?.btnSubmit.stop()
            self?.popVC()
            
        }) { [weak self] (error) in
            self?.btnSubmit.stop()
        }
    }
    
}
