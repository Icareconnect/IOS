//
//  PayOutVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 13/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class PayOutVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAvailbableBalanceTitle: UILabel!
    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var btnPayOut: UIButton!
    @IBOutlet weak var lblAddBank: UILabel!
    @IBOutlet weak var tfAccountNumber: JVFloatLabeledTextField!
    @IBOutlet weak var tfAccountName: JVFloatLabeledTextField!
    @IBOutlet weak var tfIFSCCode: JVFloatLabeledTextField!
    @IBOutlet weak var tfBankName: JVFloatLabeledTextField!
    @IBOutlet weak var tfCountry: JVFloatLabeledTextField!
    @IBOutlet weak var tfCurrency: JVFloatLabeledTextField!
    @IBOutlet weak var tfAddress: JVFloatLabeledTextField!
    @IBOutlet weak var tfCity: JVFloatLabeledTextField!
    @IBOutlet weak var tfProvience: JVFloatLabeledTextField!
    @IBOutlet weak var tfPostalCode: JVFloatLabeledTextField!
    
    @IBOutlet weak var tfInstitution: JVFloatLabeledTextField!
    
    @IBOutlet weak var btnIndependent: UIButton!
    @IBOutlet weak var btnTemporary: UIButton!
    
    var customerType = "Independent Contractor"
    var balance: Double?
    private var bankId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnIndependent.isSelected = true
        btnIndependent.titleLabel?.numberOfLines = 2
        btnTemporary.titleLabel?.numberOfLines = 2
        
        getWalletBalanceAPI()
        getBanksAPI()
        localizedTextSetup()
        tfAccountNumber.addTarget(self, action: #selector(validateValues), for: .editingChanged)
        tfAccountName.addTarget(self, action: #selector(validateValues), for: .editingChanged)
        tfIFSCCode.addTarget(self, action: #selector(validateValues), for: .editingChanged)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Pay Out
            addBankAPI()
            
        case 2:
            btnIndependent.isSelected = true
            btnTemporary.isSelected = false
            
        case 3:
            btnIndependent.isSelected = false
            btnTemporary.isSelected = true
            
        default:
            break
        }
    }
    
    
    private func actionCountry() {
        
        actionSheet(for: [VCLiteral.CA.localized, VCLiteral.IN.localized, VCLiteral.US.localized], title: VCLiteral.SELECT_COUNTRY.localized, message: nil, view: nil) { (selected) in
            
            self.tfCountry.text = /selected
        }
    }
    
    private func actionCurrency() {
        
        actionSheet(for: [VCLiteral.CAD.localized, VCLiteral.INR.localized, VCLiteral.USD.localized], title: VCLiteral.SELECT_CURRENCY.localized, message: nil, view: nil) { (selected) in
            
            self.tfCurrency.text = /selected
        }
        
    }
    
}

//MARK:- VCFuncs
extension PayOutVC {
    
    @objc private func validateValues() {
        //        if /tfAccountName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || /tfAccountNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || /tfIFSCCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  || /tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  || /tfCity.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  || /tfProvience.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  || /tfPostalCode.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        //            btnPayOut.alpha = 0.5
        //            btnPayOut.isUserInteractionEnabled = false
        //        } else {
        //            btnPayOut.alpha = 1.0
        //            btnPayOut.isUserInteractionEnabled = true
        //        }
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.ACCOUNT_DETAILS.localized
        lblAvailbableBalanceTitle.text = VCLiteral.AVAILABLE_BALANCE.localized
        lblAvailableBalance.text = /balance?.getFormattedPrice()
        btnPayOut.setTitle(VCLiteral.UPDATE.localized, for: .normal)
        lblAddBank.text = VCLiteral.BANK_DETAILS.localized
        tfAccountNumber.placeholder = VCLiteral.ACCOUNT_NUMBER.localized
        tfAccountName.placeholder = VCLiteral.ACCOUNT_NAME.localized
        tfIFSCCode.placeholder = VCLiteral.TRANSIT_NUMBER.localized
        tfInstitution.placeholder = VCLiteral.INST_NUMBER.localized
        tfBankName.placeholder = VCLiteral.BANK_NAME.localized
        tfCurrency.placeholder = VCLiteral.SELECT_CURRENCY.localized
        tfCountry.placeholder = VCLiteral.SELECT_COUNTRY.localized
        validateValues()
    }
    
    private func setBankValues(_ data: Bank?) {
        tfAccountNumber.text = /data?.account_number
        tfAccountName.text = /data?.name
        tfBankName.text = /data?.bank_name
        tfIFSCCode.text = /data?.ifc_code
        tfCountry.text = /data?.country
        tfCurrency.text = /data?.currency
        tfInstitution.text = /data?.institution_number
        tfAddress.text = /data?.address
        tfCity.text = /data?.city
        tfProvience.text = /data?.province
        tfPostalCode.text = /data?.postal_code
        
        btnTemporary.isSelected = /data?.customer_type == /btnTemporary.titleLabel?.text
        btnIndependent.isSelected = /data?.customer_type == /btnIndependent.titleLabel?.text
        
        //        validateValues()
    }
    
    
    private func getWalletBalanceAPI() {
        EP_Home.wallet.request(success: { [weak self] (responseData) in
            self?.balance = (responseData as? WalletBalance)?.balance
            self?.lblAvailableBalance.text = /self?.balance?.getFormattedPrice()
        }) { (error) in
            
        }
    }
    
    private func getBanksAPI() {
        playLineAnimation()
        EP_Home.banks.request(success: { [weak self] (response) in
            let data = response as? BanksData
            self?.bankId = data?.bank_accounts?.first?.id != nil ? "\(/data?.bank_accounts?.first?.id)" : nil
            self?.setBankValues(data?.bank_accounts?.first)
            self?.stopLineAnimation()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
    
    private func addBankAPI() {
        playLineAnimation()
        EP_Home.addBank(country: tfCountry.text, currency: tfCurrency.text, account_holder_name: tfAccountName.text, account_holder_type: "individual", ifc_code: tfIFSCCode.text, account_number: tfAccountNumber.text, bank_name: tfBankName.text, bank_id: bankId, institution_number: tfInstitution.text,address: /tfAddress.text, city: tfCity.text, province: tfProvience.text , postal_code: tfPostalCode.text, customer_type: btnIndependent.isSelected ? /btnIndependent.titleLabel?.text : /btnTemporary.titleLabel?.text).request(success: { [weak self] (response) in
            let data = response as? BanksData
            self?.bankId = data?.bank_accounts?.first?.id != nil ? "\(/data?.bank_accounts?.first?.id)" : nil
            self?.setBankValues(data?.bank_accounts?.first)
            self?.stopLineAnimation()
            //            self?.payoutAPI()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
    
    private func payoutAPI() {
        playLineAnimation()
        EP_Home.payouts(bankId: bankId, amount: String(/balance)).request(success: { [weak self] (response) in
            self?.stopLineAnimation()
            self?.popVC()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
}
extension PayOutVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == tfCountry {
            
            actionCountry()
            return false
        } else if textField == tfCurrency {
            
            actionCurrency()
            return false
        }
        return true
    }
}
